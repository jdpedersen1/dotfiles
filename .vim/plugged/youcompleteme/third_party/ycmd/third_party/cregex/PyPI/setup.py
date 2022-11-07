#!/usr/bin/env python
from os.path import abspath, dirname, join
import sys

try:
    from setuptools import setup, Extension
except ImportError:
    from distutils.core import setup, Extension

MAJOR, MINOR = sys.version_info[:2]
BASE_DIR = dirname(abspath(__file__))
print('BASE_DIR is %s' % BASE_DIR)

PKG_BASE = 'regex_%i' % MAJOR
DOCS_DIR = join(BASE_DIR, 'docs')

setup(
    name='regex',
    version='2019.06.08',
    description='Alternative regular expression module, to replace re.',
    long_description=open(join(DOCS_DIR, 'Features.rst')).read(),

    # PyPI does spam protection on email addresses, no need to do it here
    author='Matthew Barnett',
    author_email='regex@mrabarnett.plus.com',

    maintainer='Matthew Barnett',
    maintainer_email='regex@mrabarnett.plus.com',

    url='https://bitbucket.org/mrabarnett/mrab-regex',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Python Software Foundation License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Topic :: Scientific/Engineering :: Information Analysis',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'Topic :: Text Processing',
        'Topic :: Text Processing :: General',
        ],
    license='Python Software Foundation License',

    py_modules=['regex.__init__', 'regex.regex', 'regex._regex_core',
     'regex.test.__init__', 'regex.test.test_regex'],
    package_dir={'': PKG_BASE},

    ext_modules=[Extension('regex._regex', [join(PKG_BASE, '_regex.c'),
      join(PKG_BASE, '_regex_unicode.c')])],
    )
