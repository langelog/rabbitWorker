from setuptools import setup, find_packages
from dotenv import load_dotenv
import os

load_dotenv()

setup(
    name=os.environ["SERVICE"],
    version=os.environ["VERSION"],
    description="This is an example package",
    author=os.environ["AUTHOR"],
    install_requires=[],
    packages=find_packages(),
    entry_points={
        "console_scripts": [
            'service = service.main:main'
        ]
    }
)
