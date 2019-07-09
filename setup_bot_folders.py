import os

def add_usage_content(filename, sample_file):

    with open(sample_file, 'r') as sample_file:
        sample_content = sample_file.read()
        with open(filename, 'w') as ability_file:
            ability_file.write(sample_content)

with open('npc_dota_hero_names.txt') as dota_heroes:

    for k, i  in enumerate(dota_heroes):

        sname = i.strip().split('_')[3:]
        name = '_'.join(sname)

        ability_file = name + '/ability_usage.lua'
        item_file = name + '/item_usage.lua'

        
        if not os.path.isdir(name):
            os.mkdir(name)

        if not os.path.isfile(ability_file):
            add_usage_content(ability_file, 'sample_ability_usage.lua')

        if not os.path.isfile(item_file):
            add_usage_content(item_file, 'sample_item_usage.lua')
