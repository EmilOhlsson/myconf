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


def get_caption(file_name):
    timstamp = None
    description = None
    with Image.open(file_name) as im:
        exif = im.getexif()
        ifd = exif.get_ifd(ExifTags.IFD.Exif)
        resolve = ExifTags.TAGS
        for k,v in ifd.items():
            tag = resolve.get(k, k)
            if tag == 'UserComment':
                print('Found beskrivning')
                description = v.decode('utf-8')
            if tag == 'DateTimeOriginal':
                timestamp = datetime.strptime(v, '%Y:%m:%d %H:%M:%S')
    text = None
    if timestamp is not None:
        text = f'{timestamp.strftime("%Y-%m-%d")}'
    ## This would work, but Wand doesn't handle å ä ö...
    # if description is not None:
    #     if text is not None:
    #         text = f'{text}: {description}'
    #     else:
    #         text = description
    return text


def main():
    parser = argparse.ArgumentParser(prog = 'Collage builder',
                                     description = 'join images into same sized montages')
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
    parser.add_argument('--font', help='Caption font', type=str,
                        default='/usr/share/fonts/dejavu-sans-fonts/DejaVuSans.ttf')
    parser.add_argument('--annotate', help='Write image annotation', action='store_true')
    parser.add_argument('files', metavar='FILE', type=str, nargs='+')
    args = parser.parse_args()

    directory = args.output
    width, height = [int(v) for v in args.resolution.split('x')]
    width_border = get_border_pixels(width, args.border)
    height_border = get_border_pixels(height, args.border)
    height_text = get_border_pixels(height_border, 90)
    ratio = (width + width_border) / (height + height_border)
    color = args.border_color
    font = wand.font.Font(args.font)
    print(f'out={directory}, w={width}, h={height}, ratio={ratio}')

    if os.path.exists(directory):
        print('Directory already exists')
        sys.exit(1)
    os.makedirs(directory)

    # Loop through all images in sets of four, and create an output montage image
    # which will be the resulting image with the four images combined
    for id, file_set in enumerate(chunked(args.files, args.pictures)):
        with wand.image.Image() as montage:
            # For each image in the set of four images, resize and add a white border
            for file_name in file_set:
                with wand.image.Image(filename=file_name) as img:
                    img.transform(resize=f'{width}x{height}')
                    img.border(wand.image.Color(color), width_border, height_border)
                    if args.annotate:
                        caption = get_caption(file_name)
                        if caption is not None:
                            img.caption(caption,
                                        top=height + height_border, left=width_border,
                                        width=width, height=height_text,
                                        font=font)
                    montage.image_add(img)
            montage.montage(mode='concatenate')
            output_filename = os.path.join(directory, f'montage_{id:04d}.{args.format}')
            montage.save(filename=output_filename)


if __name__ == '__main__':
    main()
