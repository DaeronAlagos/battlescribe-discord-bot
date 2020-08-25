import unittest
from bot.roster import Roster


class TestFilenamePrefix(unittest.TestCase):

    def setUp(self):
        super(TestFilenamePrefix, self).setUp()
        self.name = 'nametest.rosz'
        self.url = 'https://'
        self.roster = Roster(self.name, self.url)

    def test_prefix(self):
        name = self.roster.get_filename_prefix(self.name)
        expected = 'nametest'
        self.assertEqual(name, expected)

    def test_prefix_failure(self):
        name = self.roster.get_filename_prefix(self.name)
        expected = 'notnametest'
        self.assertNotEqual(name, expected)

    def test_suffix_failure(self):
        with self.assertRaises(Exception) as context:
            self.roster.get_filename_prefix('nametestfail')

        self.assertTrue('Not a valid roster file' in str(context.exception))
