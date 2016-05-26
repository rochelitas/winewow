#! /usr/bin/env python
# -*- coding: utf8 -*-
import os
import sys
import datetime


class WTF(object):

    def __init__(self):
        self.fname = None
        self.dirty = False
        self.lines = []
        return

    def load(self, fname):
        import codecs
        self.dirty = False
        self.fname = fname
        self.lines = []
        f = codecs.open(self.fname, 'r', 'utf-8')
        while True:
            s = f.readline()
            if s == '':
                break
            s = s.rstrip('\r\n')
            self.lines.append(s)
        f.close()
        return

    def get_value(self, key):
        import re
        rx = re.compile('^SET %s "(.*)"$' % key, re.IGNORECASE)
        for ix in range(len(self.lines)):
            r = rx.search(self.lines[ix])
            if r:
                return r.group(1)
        return None

    def set_value(self, key, value):
        import re
        rx = re.compile('^SET (%s) "(.*)"$' % key, re.IGNORECASE)
        for ix in range(len(self.lines)):
            r = rx.search(self.lines[ix])
            if r:
                if value == r.group(2):
                    return
                self.lines[ix] = 'SET %s "%s"' % (r.group(1), value)
                self.dirty = True
                return
        self.lines.append('SET %s "%s"' % (key, value))
        self.dirty = True
        return

    def patch(self, patch):
        for k, v in patch.items():
            self.set_value(k, v)
        return

    def save(self):
        import os
        import datetime
        import codecs
        if not self.dirty:
            return
        bkname = "%s.backup-%s" % (
            self.fname,
            datetime.datetime.now().strftime("%Y%m%d_%H%M%S"))
        os.rename(self.fname, bkname)
        f = codecs.open(self.fname, 'w', 'utf-8')
        for s in self.lines:
            f.write(s + '\r\n')
        f.close()
        return


if __name__ == '__main__':
    import os.path
    patch = {
        'M2UseShaders': "0",
        'UseVertexShaders': "0",
        'useWeatherShaders': "0",
        'ffxGlow': "0",
        'ffxDeath': "0",
        'ffxSpecial': "0",
        'weatherDensity': "0",
        'reflectionMode': "0",
        'maxFPS': "60",
        'ffx': "0",
        'maxFPSBk': "5",
        'mapShadows': "0",
#        'gxAPI': "opengl",
        'gxApi': "D3D9",
    }
    if len(sys.argv) == 1:
        print(("use %s wowdir [...]" % sys.argv[0]))
        sys.exit(1)
    # mydir = os.path.dirname(os.path.realpath(__file__))
    for wowdir in sys.argv[1:]:
        wtfname = wowdir + "/WTF/Config.wtf"
        if not os.path.exists(wtfname):
            print(("config file %s not found" % wtfname))
            continue
        wtf = WTF()
        print(("load %s" % wtfname))
        wtf.load(wtfname)
        wtf.patch(patch)
        if wtf.dirty:
            print(("save patched %s" % wtfname))
            wtf.save()
            print(("file saved"))
        else:
            print(("no changes. no write back"))
    print(("done."))
