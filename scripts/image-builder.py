#!/usr/bin/env python3

"""Work through pictures and create montage pictures of same size"""

from more_itertools import chunked
from datetime import datetime
from dataclasses import dataclass

import argparse
import os
import sys
import math

from typing import Any, Dict, Optional, Tuple

from PIL import Image, ExifTags, ImageColor, ImageDraw, ImageFont, ImageOps

def extract_date_from_exif_dict(exif_dict: Dict[int, Any]) -> Optional[str]:
    """Extract date from EXIF dictionary and return formatted string"""
    # Use proper EXIF tag constants (in order of preference)
    date_tag_ids = [
        ExifTags.Base.DateTimeOriginal.value,  # when photo was taken
        ExifTags.Base.DateTime.value,          # when file was modified
        ExifTags.Base.DateTimeDigitized.value, # when photo was digitized
    ]

    for tag_id in date_tag_ids:
        if tag_id in exif_dict:
            date_value: str = exif_dict[tag_id]
            if date_value:
                try:
                    # Parse datetime string format: "YYYY:MM:DD HH:MM:SS"
                    date_str = date_value.split()[0]  # Get just the date part
                    year, month, day = date_str.split(':')
                    return f"{year}-{month}-{day}"
                except (ValueError, IndexError) as e:
                    # Skip malformed date values and try next tag
                    print(f"Malformed date value '{date_value}' in EXIF tag {tag_id}: {e}")
                    continue

    return None


def extract_description_from_exif_dict(exif_dict: Dict[int, Any]) -> Optional[str]:
    """Extract image description from EXIF dictionary"""
    # Try to get image description
    desc_tag_id = ExifTags.Base.ImageDescription.value

    if desc_tag_id in exif_dict:
        description: str = exif_dict[desc_tag_id]
        if description and description.strip():
            return description.strip()

    return None


def create_annotation_text(img: Image.Image) -> Optional[str]:
    """Create annotation text combining date and description from EXIF data"""
    exif_dict = img.getexif()
    if not exif_dict:
        return None

    date_str = extract_date_from_exif_dict(exif_dict)
    if not date_str:
        return None

    description = extract_description_from_exif_dict(exif_dict)

    if description:
        return f"{date_str}: {description}"

    return date_str


def add_annotation_to_image(img: Image.Image, annotation: str, border_height: int, text_size_percent: int) -> Image.Image:
    """Add annotation text to the bottom border area of the image

    The image has borders on all sides. The actual photo content is in the middle,
    and we want to place text in the bottom border area with a small gap from the photo.
    Note: img is the already-bordered image from add_border()
    """
    # Calculate font size based on percentage of border height
    font_size = int(border_height * text_size_percent / 100)

    # Try to load a system font, fall back to default if not available
    try:
        font = ImageFont.truetype("arial.ttf", font_size)
    except (OSError, IOError):
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Arial.ttf", font_size)  # macOS
        except (OSError, IOError):
            try:
                font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", font_size)  # Linux
            except (OSError, IOError):
                font = ImageFont.load_default()

    # Create a copy of the image to draw on
    annotated_img = img.copy()
    draw = ImageDraw.Draw(annotated_img)

    # Get text bounding box to understand dimensions
    bbox = draw.textbbox((0, 0), annotation, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    # Calculate position to center text horizontally
    x = (img.width - text_width) // 2

    # The photo bottom is at (img.height - border_height)
    # We want the text fully in the border area with separation from photo
    separation_from_image = max(5, int(border_height * 0.1))  # At least 2 pixels
    photo_bottom = img.height - border_height

    # Position the text so its top is below the photo with separation
    # Since bbox[1] is typically negative (text extends above origin),
    # and bbox[3] is positive (text extends below origin),
    # we need to position accounting for the full text height
    # We want the top of text to be at (photo_bottom + separation)
    # When we draw at position y, the top of text will be at (y + bbox[1])
    # So: y + bbox[1] = photo_bottom + separation
    # Therefore: y = photo_bottom + separation - bbox[1]
    # But since bbox[1] is negative, this means: y = photo_bottom + separation + abs(bbox[1])

    # Calculate y position - place text fully below photo with separation
    y = photo_bottom + separation_from_image + abs(bbox[1])

    # Draw text in black
    draw.text((x, y), annotation, fill='black', font=font)

    return annotated_img


@dataclass
class MontageConfig:
    """Configuration for montage creation"""
    montage_width: int
    montage_height: int
    num_images: int
    border_percent: int
    border_color: str
    sub_width: int
    sub_height: int
    width_border: int
    height_border: int

    @classmethod
    def from_args(cls, montage_width: int, montage_height: int, num_images: int,
                  border_percent: int, border_color: str) -> 'MontageConfig':
        """Create MontageConfig from command line arguments"""
        # Calculate sub-image dimensions
        if num_images == 1:
            cols, rows = 1, 1
        elif num_images == 2:
            cols, rows = 2, 1
        elif num_images == 4:
            cols, rows = 2, 2
        else:
            raise ValueError(f"Unsupported number of images: {num_images}")

        # Calculate sub-image dimensions including borders
        sub_width_with_border = montage_width // cols
        sub_height_with_border = montage_height // rows

        # Calculate border pixels
        width_border = get_border_pixels(sub_width_with_border, border_percent)
        height_border = get_border_pixels(sub_height_with_border, border_percent)

        # Calculate actual image area (excluding borders)
        sub_width = sub_width_with_border - 2 * width_border
        sub_height = sub_height_with_border - 2 * height_border

        return cls(
            montage_width=montage_width,
            montage_height=montage_height,
            num_images=num_images,
            border_percent=border_percent,
            border_color=border_color,
            sub_width=sub_width,
            sub_height=sub_height,
            width_border=width_border,
            height_border=height_border
        )

def get_border_pixels(dimension: int, border_percent: int) -> int:
    """Calculate border pixels from percentage"""
    return int(dimension * border_percent / 100)

def resize_with_aspect_ratio(img: Image.Image, target_width: int, target_height: int) -> Image.Image:
    """Resize image while preserving aspect ratio"""
    original_width, original_height = img.size

    # Calculate scaling factor to fit within target dimensions
    width_ratio = target_width / original_width
    height_ratio = target_height / original_height
    scale_factor = min(width_ratio, height_ratio)

    new_width = int(original_width * scale_factor)
    new_height = int(original_height * scale_factor)

    return img.resize((new_width, new_height), Image.Resampling.LANCZOS)

def will_be_rotated(img: Image.Image, position: int, config: MontageConfig) -> bool:
    """Determine if image will be rotated based on position and layout"""
    if config.num_images == 1:
        return False

    if config.num_images == 2:
        # Images are rotated if they're landscape oriented
        return img.width > img.height

    if config.num_images == 4:
        # All images are rotated in 4-image layout
        # (either 90, -90, or 180 degrees)
        return True

    return False

def resize_for_slot_considering_rotation(img: Image.Image, position: int, config: MontageConfig) -> Image.Image:
    """Resize image to fit the sub-image slot, considering if it will be rotated"""
    # Check if this image will be rotated based on position
    if will_be_rotated(img, position, config):
        # If image will be rotated 90 or -90 degrees, swap the target dimensions
        # (180 degree rotation doesn't change dimensions)
        if config.num_images == 2:
            # 2-image layout: landscape images get 90/-90 rotation
            target_width = config.sub_height
            target_height = config.sub_width
        elif config.num_images == 4:
            # 4-image layout: need to check specific position
            if position in [0, 1]:  # Top positions
                if img.height > img.width:  # Portrait images get 90/-90
                    target_width = config.sub_height
                    target_height = config.sub_width
                else:  # Landscape images get 180
                    target_width = config.sub_width
                    target_height = config.sub_height
            else:  # Bottom positions (2, 3)
                if img.height > img.width:  # Portrait images get 90/-90
                    target_width = config.sub_height
                    target_height = config.sub_width
                else:  # Landscape images stay as is
                    target_width = config.sub_width
                    target_height = config.sub_height
        else:
            target_width = config.sub_width
            target_height = config.sub_height
    else:
        # No rotation, use normal dimensions
        target_width = config.sub_width
        target_height = config.sub_height

    return resize_with_aspect_ratio(img, target_width, target_height)

def add_border(img: Image.Image, position: int, config: MontageConfig) -> Image.Image:
    """Add border to image and center it, considering if it will be rotated"""
    # Determine if image will be rotated (to swap dimensions)
    swap_dims = False
    if config.num_images == 2 and img.width > img.height:
        swap_dims = True
    elif config.num_images == 4:
        # Check if it's a 90/-90 degree rotation (which swaps dimensions)
        if position in [0, 1]:  # Top positions
            if img.height > img.width:  # Portrait gets 90/-90
                swap_dims = True
        else:  # Bottom positions
            if img.height > img.width:  # Portrait gets 90/-90
                swap_dims = True

    # Calculate total dimensions including border
    if swap_dims:
        # Image will be rotated 90/-90, so swap the slot dimensions
        total_width = config.sub_height + 2 * config.height_border
        total_height = config.sub_width + 2 * config.width_border
        actual_sub_width = config.sub_height
        actual_sub_height = config.sub_width
        actual_width_border = config.height_border
        actual_height_border = config.width_border
    else:
        total_width = config.sub_width + 2 * config.width_border
        total_height = config.sub_height + 2 * config.height_border
        actual_sub_width = config.sub_width
        actual_sub_height = config.sub_height
        actual_width_border = config.width_border
        actual_height_border = config.height_border

    # Create new image with border color
    bordered_img = Image.new('RGB', (total_width, total_height), config.border_color)

    # Calculate position to center the image
    paste_x = actual_width_border + (actual_sub_width - img.width) // 2
    paste_y = actual_height_border + (actual_sub_height - img.height) // 2

    # Paste the image onto the bordered background
    bordered_img.paste(img, (paste_x, paste_y))

    return bordered_img

def is_portrait(img: Image.Image) -> bool:
    """Check if image is in portrait mode (height > width)"""
    return img.height > img.width

def is_landscape(img: Image.Image) -> bool:
    """Check if image is in landscape mode (width > height)"""
    return img.width > img.height

def rotate_image_for_position(img: Image.Image, position: int, config: MontageConfig) -> Image.Image:
    """Rotate image based on position and layout to ensure bottom is at montage edge"""
    if config.num_images == 1:
        # Single image - no special rotation needed
        return img

    if config.num_images == 2:
        # Left image (position 0): rotate right if landscape oriented
        # Right image (position 1): rotate left if landscape oriented
        if position == 0 and img.width > img.height:
            return img.rotate(-90, expand=True)  # Rotate right (clockwise)
        elif position == 1 and img.width > img.height:
            return img.rotate(90, expand=True)   # Rotate left (counter-clockwise)
        else:
            return img

    if config.num_images == 4:
        # Top left (0): rotate right if portrait, upside down if landscape
        # Top right (1): rotate left if portrait, upside down if landscape
        # Bottom left (2): rotate right if portrait, unchanged if landscape
        # Bottom right (3): rotate left if portrait, unchanged if landscape
        if position == 0:  # Top left
            if img.height > img.width:
                return img.rotate(-90, expand=True)  # Rotate right
            else:
                return img.rotate(180, expand=True)  # Upside down
        elif position == 1:  # Top right
            if img.height > img.width:
                return img.rotate(90, expand=True)   # Rotate left
            else:
                return img.rotate(180, expand=True)  # Upside down
        elif position == 2:  # Bottom left
            if img.height > img.width:
                return img.rotate(-90, expand=True)  # Rotate right
            else:
                return img  # Unchanged
        elif position == 3:  # Bottom right
            if img.height > img.width:
                return img.rotate(90, expand=True)   # Rotate left
            else:
                return img  # Unchanged

    return img

def create_montage(images: list, config: MontageConfig) -> Image.Image:
    """Create montage from list of images"""
    if not images:
        raise ValueError("No images provided")

    # Calculate grid dimensions
    if config.num_images == 1:
        cols, rows = 1, 1
    elif config.num_images == 2:
        cols, rows = 2, 1
    elif config.num_images == 4:
        cols, rows = 2, 2
    else:
        raise ValueError(f"Unsupported number of images: {config.num_images}")

    # Create montage canvas
    montage = Image.new('RGB', (config.montage_width, config.montage_height), 'white')

    # Calculate sub-image dimensions
    sub_width_with_border = config.montage_width // cols
    sub_height_with_border = config.montage_height // rows

    # Paste images into montage
    for i, img in enumerate(images[:config.num_images]):
        col = i % cols
        row = i // cols
        x = col * sub_width_with_border
        y = row * sub_height_with_border
        montage.paste(img, (x, y))

    return montage

def main():
    parser = argparse.ArgumentParser(prog='Collage builder',
                                     description='join images into montages')
    parser.add_argument('--annotate', action='store_true',
                        help='Add date annotations from EXIF data to image borders')
    parser.add_argument('--text_size', help='Size of annotation text as %% of border height',
                        default=60, type=int)
    parser.add_argument('--resolution',
                        help='Resolution of montage image of the form WxH',
                        type=str, default='6240x4160')
    parser.add_argument('--border', help='amount of picture border in %%',
                        default=5, type=int)
    parser.add_argument('--format', help='Picture output format extension',
                        default='jpg', type=str)
    parser.add_argument('--border_color', help='Color of image border',
                        default='White', type=str)
    parser.add_argument('--pictures', default=4, type=int,
                        choices=[1,2,4],
                        help='Number of pictures per montage')
    parser.add_argument('--output', help='Output directory',
                        type=str, default='montage_images')
    parser.add_argument('files', metavar='FILE', type=str, nargs='+')
    args = parser.parse_args()

    directory = args.output
    montage_width, montage_height = [int(v) for v in args.resolution.split('x')]

    # Assert that output resolution is in landscape format
    assert montage_width > montage_height, f"Output resolution must be landscape (width > height), got {montage_width}x{montage_height}"

    # Create montage configuration
    config = MontageConfig.from_args(
        montage_width=montage_width,
        montage_height=montage_height,
        num_images=args.pictures,
        border_percent=args.border,
        border_color=args.border_color
    )

    print(f'out={directory}, montage resolution={config.montage_width}x{config.montage_height}')
    print(f'sub-image size={config.sub_width}x{config.sub_height}, border={config.width_border}x{config.height_border}')

    if os.path.exists(directory):
        print('Directory already exists')
        sys.exit(1)
    os.makedirs(directory)

    # Loop through all images in sets, and create an output montage
    # image which will be the resulting image with the images combined.
    # Images are rotated according to position to ensure bottom edge alignment
    for p_id, file_set in enumerate(chunked(args.files, args.pictures)):
        processed_images = []

        # For each image in the set, follow the correct processing order
        for position, file_name in enumerate(file_set):
            with Image.open(file_name) as img:
                # Convert to RGB if necessary
                if img.mode != 'RGB':
                    img = img.convert('RGB')

                # Apply EXIF orientation FIRST - this must be the first step
                img = ImageOps.exif_transpose(img)

                # Extract annotation from properly oriented image
                annotation = None
                if args.annotate:
                    annotation = create_annotation_text(img)

                # Resize image considering if it will be rotated
                img = resize_for_slot_considering_rotation(img, position, config)

                # Add border (considering rotation)
                img = add_border(img, position, config)

                # Add annotation to border if enabled
                if annotation:
                    img = add_annotation_to_image(img, annotation, config.height_border, args.text_size)

                # Rotate image as required by montage position
                img = rotate_image_for_position(img, position, config)

                processed_images.append(img)

        # Create montage
        montage = create_montage(processed_images, config)

        # Save montage
        output_filename = os.path.join(
            directory, f'montage_{p_id:04d}.{args.format}')

        # Set quality for JPEG
        save_kwargs = {}
        if args.format.lower() in ['jpg', 'jpeg']:
            save_kwargs['quality'] = 95
            save_kwargs['optimize'] = True

        montage.save(output_filename, **save_kwargs)
        print(f"Created: {output_filename}")


if __name__ == '__main__':
    main()

# vim: set et ts=4 sw=4 ss=4 tw=80 :
