import os
import re
import pprint

hero_abilities = {}
with open('npc_dota_hero_names.txt') as dota_heroes:

    for k, i  in enumerate(dota_heroes):

        sname = i.strip().split('_')[3:]
        name = '_'.join(sname)
        hero_abilities[name] = []

with open('../../npc/npc_heroes.txt', 'r') as npc_heroes:
	for line in npc_heroes.readlines():
		lines = line.rstrip()

		for i in range(1, 7):
			pattern = r'\t{2}"Ability'+str(i)+r'"\t+"(.*)"'
			matched = re.match(pattern, lines)
			if matched and "generic_hidden" not in lines:
				group = matched.group(1)
				if group:
					for hero_name in hero_abilities.keys():
						if group.startswith(hero_name):
							hero_abilities[hero_name].append(group)

for k, v in hero_abilities.items():
	if os.path.isdir(k):
		with open(k+'/abilities.txt', 'w') as abilities:
			abilities.write('\n'.join(v))

# pp = pprint.PrettyPrinter(indent=4)
# pp.pprint(hero_abilities)
