#!/usr/bin/env python3

import sys
import re
import xml.etree.cElementTree as et

et.register_namespace('dc', "http://purl.org/dc/elements/1.1/")
et.register_namespace('cc', "http://creativecommons.org/ns#")
et.register_namespace('rdf', "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
et.register_namespace('svg', "http://www.w3.org/2000/svg")
et.register_namespace('', "http://www.w3.org/2000/svg")
et.register_namespace('sodipodi', "http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd")
et.register_namespace('inkscape', "http://www.inkscape.org/namespaces/inkscape")

if len(sys.argv) < 2:
    print("usage: %s SVG-FILE" % sys.argv[0])
    sys.exit(1)

svg_doc = et.parse(sys.argv[1])
svg_obj = svg_doc.getroot()

ns = {}

if svg_obj.tag[0] == '{':
    tagspl = svg_obj.tag[1:].split('}')
    ns[tagspl[1]] = tagspl[0];

g_tag = '{' + ns['svg'] + '}g'

show_layers = []
hide_layers = []
steps = 0

for gr in svg_obj.iter(g_tag):
    mode = None
    label = None
    for attr in gr.attrib:
        if re.fullmatch('\{.*\}groupmode', attr):
            mode = gr.attrib[attr]
        if re.fullmatch('\{.*\}label', attr):
            label = gr.attrib[attr]
    if mode == 'layer':
        print("Layer with spec: ", label)
        show_at_start = False

        for per in label.split(','):
            subs = per.split('-')
            off = None
            end = None
            if len(subs) == 1:
                off = end = int(subs[0])
            else:
                off = 0 if subs[0] == '' else int(subs[0])
                end = -1 if subs[1] == '' else int(subs[1])

            if off >= steps or end >= steps:
                steps_new = max(off, end) + 1
                show_layers = show_layers + [ [] for v in range(steps, steps_new)]
                hide_layers = hide_layers + [ [] for v in range(steps, steps_new)]
                steps = steps_new

            if off > 0:
                show_layers[off - 1].append(gr)

            if end >= 0:
                hide_layers[end].append(gr)

            if off == 0:
                show_at_start = True

        gr.attrib['style'] = 'display:inline' if show_at_start else 'display:none'

temp_svg_files = []

for step in range(steps):
    #filename = sys.argv[1][:-4] + '_' + str(step) + '.svg'
    filename = 'circbuf_%02d.svg' % (step + 1)
    temp_svg_files.append(filename)

    svg_doc.write(filename, 'utf-8', True, None, 'xml')

    for layer in show_layers[step]:
        layer.attrib['style'] = 'display:inline'
    for layer in hide_layers[step]:
        layer.attrib['style'] = 'display:none'

import subprocess

temp_pdf_files = []

for svg_file in temp_svg_files:
    pdf_file = svg_file[:-4] + '.pdf'
    temp_pdf_files.append(pdf_file)

    subprocess.run(['inkscape', svg_file, '--export-pdf=' + pdf_file])
    subprocess.run(['rm', svg_file])
