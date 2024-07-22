#!/usr/bin/env python3

"""Work through pictures and create montage pictures of same size"""

from more_itertools import chunked
from datetime import datetime

import argparse
import os
import sys
import wand
import wand.color
import wand.image
import wand.font

from PIL import Image, ExifTags


def get_border_pixels(pixels: int, percentage: int):
    return (pixels * percentage) // 100


def main():
    parser = argparse.ArgumentParser(prog='Collage builder',
                                     description='join images into montages')
    parser.add_argument('--resolution',
                        help='Resolution of scaled images of the form WxH',
                        type=str, default='3120x2080')
    parser.add_argument('--border', help='amount of picture border in %%',
                        default=5, type=int)
    parser.add_argument('--format', help='Picture output format extension',
                        default='jpg', type=str)
    parser.add_argument('--border_color', help='Color of image border',
                        default='White', type=str)
    parser.add_argument('--pictures', default=4, type=int,
                        help='Number of pictures per montage')
    parser.add_argument('--output', help='Output directory',
                        type=str, default='montage_images')
    parser.add_argument('files', metavar='FILE', type=str, nargs='+')
    args = parser.parse_args()

    directory = args.output
    width, height = [int(v) for v in args.resolution.split('x')]
    width_border = get_border_pixels(width, args.border)
    height_border = get_border_pixels(height, args.border)
    ratio = (width + width_border) / (height + height_border)
    color = args.border_color
    print(f'out={directory}, resolution={width}x{height}, ratio={ratio}')

    if os.path.exists(directory):
        print('Directory already exists')
        sys.exit(1)
    os.makedirs(directory)

    # Loop through all images in sets of four, and create an output montage
    # image which will be the resulting image with the four images combined.
    # If an image is in portrait mode, then rotate 90 degrees
    for id, file_set in enumerate(chunked(args.files, args.pictures)):
        with wand.image.Image() as montage:
            # For each image in the set of four images,
            # resize and add a white border
            for file_name in file_set:
                with wand.image.Image(filename=file_name) as img:
                    if img.width < img.height:
                        img.rotate(90)
                    # Resize image, preserve aspect ratio
                    img.transform(resize=f'{width}x{height}')
                    pad_vertical = height_border + (height - img.height) // 2
                    pad_horizontal = width_border + (width - img.width) // 2
                    img.border(wand.image.Color(color),
                               pad_horizontal, pad_vertical)
                    montage.image_add(img)
            # TODO: Make sure that this handles non-multiples of args.pictures
            montage.montage(mode='concatenate')
            output_filename = os.path.join(
                directory, f'montage_{id:04d}.{args.format}')
            montage.save(filename=output_filename)


if __name__ == '__main__':
    main()

# vim: set et ts=4 sw=4 ss=4 tw=80 :
