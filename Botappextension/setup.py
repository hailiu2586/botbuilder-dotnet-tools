from codecs import open
from setuptools import setup, find_packages

VERSION = "0.0.2"

CLASSIFIERS = [
    'Development Status :: 4 - Beta',
    'Intended Audience :: Developers',
    'Intended Audience :: System Administrators',
    'Programming Language :: Python',
    'Programming Language :: Python :: 2',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.4',
    'Programming Language :: Python :: 3.5',
    'Programming Language :: Python :: 3.6',
    'Programming Language :: Python :: 3.7',
    'Programming Language :: Python :: 3.8',
    'License :: OSI Approved :: MIT License',
]

DEPENDENCIES = []

setup(
    name='botappextension',
    version=VERSION,
    description='botapp CLI extension',
    long_description='botapp cli extension that helps with deployment',
    license='MIT',
    author='hailiu@microsoft.com',
    author_email='hailiu@microsoft.com',
    url='https://github.com/ORG/REPO',
    classifiers=CLASSIFIERS,
    packages=find_packages(),
    install_requires=DEPENDENCIES
)
