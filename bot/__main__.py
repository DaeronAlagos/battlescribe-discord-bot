# -*- coding: utf-8 -*-
import os
import logging
import discord
from bot import file_handler
from bot.roster import Roster

log = logging.getLogger('bot')
log.addHandler(file_handler)


class Bot(discord.Client):

    async def on_ready(self):
        log.info('Logged in as {user}'.format(user=self.user))

    async def on_message(self, message):
        if message.author == self.user:
            return
        for attachment in message.attachments:
            if attachment.filename.endswith('.rosz'):
                log.info('PDF Requested by {author.name} ({author.guild})'.format(
                    author=message.author
                ))
                roster = Roster(attachment.filename, attachment.url)
                name, pdf = roster.get_pdf()
                content = '{mention}, here is your printable roster!'.format(
                    mention=message.author.mention
                )
                pdf_file = discord.File(fp=pdf, filename=name)
                await message.channel.send(
                    content=content,
                    file=pdf_file,
                )


bot = Bot()
bot.run(os.environ.get('TOKEN'))
