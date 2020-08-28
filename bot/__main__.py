# -*- coding: utf-8 -*-
import os
import logging
import discord
from bot import file_handler, BotException
from bot.roster import Roster

log = logging.getLogger('bot')
log.addHandler(file_handler)


class Bot(discord.Client):

    async def on_ready(self):
        log.info('Connected as {user}'.format(user=self.user))
        for guild in self.guilds:
            log.info('Used by guild: {guild}'.format(guild=guild))

    async def on_message(self, message):
        author = message.author
        if author == self.user:
            return
        for attachment in message.attachments:
            if attachment.filename.endswith('.rosz'):
                try:
                    guild = author.guild
                except AttributeError:
                    guild = 'Direct Message'
                log.info('PDF Requested by {author.name} ({guild})'.format(
                    author=author,
                    guild=guild,
                ))
                roster = Roster(attachment.filename, attachment.url)
                try:
                    name, pdf = await roster.get_pdf()
                    content = '{mention} here is your printable roster!'.format(
                        mention=author.mention
                    )
                    pdf_file = discord.File(fp=pdf, filename=name)
                    await message.channel.send(
                        content=content,
                        file=pdf_file,
                    )
                    log.info('PDF Sent to {author.name} ({guild})'.format(
                        author=author,
                        guild=guild,
                    ))
                except BotException as e:
                    await message.channel.send(
                        content='{mention} {exception}'.format(
                            mention=author.mention,
                            exception=e,
                        ),
                    )


bot = Bot()
bot.run(os.environ.get('TOKEN'))
