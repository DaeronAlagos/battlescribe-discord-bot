# -*- coding: utf-8 -*-
from io import BytesIO
import os
import logging
from zipfile import ZipFile
import pdfkit
from lxml import etree as et
from requests import get
from bot import BotException, file_handler

log = logging.getLogger('roster')
log.addHandler(file_handler)


def load_xsl(filename):
    file_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), 'resources/{filename}'.format(filename=filename)
    )
    with open(file_path, 'r') as f:
        return et.parse(f)


class Roster(object):

    stylesheets = {
        'Warhammer 40,000: Kill Team (2018)': load_xsl('kill-team.xsl'),
        'Warcaster: Neo-Mechanika': load_xsl('warcaster.xsl'),
    }

    def __init__(self, name, url):
        self.name = self.get_filename_prefix(name)
        self.url = url

    @staticmethod
    def get_filename_prefix(name):
        if name.endswith('.rosz'):
            return name.rsplit('.', 1)[0]
        raise BotException('Not a valid roster file')

    def read_xml(self):
        file = self.get_file()
        if file:
            content = self.extract_content(file)
            return et.fromstring(content)
        raise BotException('Failed to read roster data')

    @staticmethod
    def extract_content(file):
        with ZipFile(file) as archive:
            for f in archive.infolist():
                if f.filename.endswith('.ros'):
                    with archive.open('{name}'.format(name=f.filename)) as roster:
                        return roster.read()
                raise BotException('Failed to read roster data')

    def get_file(self):
        result = get(self.url)
        if result.ok:
            return BytesIO(result.content)
        raise BotException('Failed to download roster')

    @staticmethod
    def get_game_system(xml):
        return xml.get('gameSystemName')

    @staticmethod
    def transform(xsl, xml):
        transform = et.XSLT(xsl)
        tree = transform(xml)
        return et.tostring(tree).decode('utf-8')

    @staticmethod
    def create_pdf(html):
        options = {
            'quiet': None,
            'disable-smart-shrinking': None,
            'print-media-type': None,
        }
        try:
            pdf = pdfkit.from_string(html, False, options=options)
            return BytesIO(pdf)
        except TypeError:
            raise BotException('An error occurred when converting to pdf')

    async def get_pdf(self):
        xml = self.read_xml()
        game_system = self.get_game_system(xml)
        xsl = Roster.stylesheets.get(game_system)
        if not xsl:
            raise BotException('Sorry, this game system is unsupported')
        html = self.transform(xsl, xml)
        pdf_buffer = self.create_pdf(html)
        return '{prefix}.pdf'.format(prefix=self.name), pdf_buffer
