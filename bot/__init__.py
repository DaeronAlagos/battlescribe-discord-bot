# -*- coding: utf-8 -*-
import logging
from logging import handlers
format_string = "%(asctime)s | %(name)s | %(levelname)s | %(message)s"
log_format = logging.Formatter(format_string)
file_handler = handlers.RotatingFileHandler(
    'logs/bot.log', maxBytes=5242880, backupCount=7, encoding='utf8'
)
file_handler.setFormatter(log_format)
logging.basicConfig(level=logging.INFO)


class BotException(Exception):
    pass
