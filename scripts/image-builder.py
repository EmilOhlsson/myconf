#!/usr/bin/env python3

"""Work through pictures and create montage pictures of same size"""

from more_itertools import chunked

import argparse
import os
import sys
import wand
import wand.color
import wand.image


def get_border_pixels(pxs: int, percent: int):
    """Calculate number of pixels for border based on integer
       percentage"""
    return (pxs * percent) // 100


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
    parser.add_argument('files', metavar='FILE', type=str, nargs='+')
    args = parser.parse_args()

    directory = args.output
    width, height = [int(v) for v in args.resolution.split('x')]
    width_border = get_border_pixels(width, args.border)
    height_border = get_border_pixels(height, args.border)
    ratio = (width + width_border) / (height + height_border)
    color = args.border_color
    print(f'out={directory}, w={width}, h={height}, ratio={ratio}')

    if os.path.exists(directory):
        print('Directory already exists')
        sys.exit(1)
    os.makedirs(directory)

    for id, file_set in enumerate(chunked(args.files, 4)):
        with wand.image.Image() as montage:
            for file_name in file_set:
                with wand.image.Image(filename=file_name) as img:
                    img.transform(resize=f'{width}x{height}')
                    img.border(wand.image.Color(color), width_border, height_border)
                    montage.image_add(img)
            montage.montage(mode='concatenate')
            output_filename = os.path.join(directory, f'montage_{id:04d}.{args.format}')
            montage.save(filename=output_filename)


if __name__ == '__main__':
    main()
