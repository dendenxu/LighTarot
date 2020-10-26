import json

# Load from rcproject file, which is a json file
with open("com.apple.RCFoundation.Project", "rb") as json_file:
    json_obj = json.load(json_file)

# Ease of access
behaviors = json_obj["__content"][0]["scenes"][0]["__content"][0]["behaviors"]
objects = json_obj["__content"][0]["scenes"][0]["__content"][0]["overrides"]["children"]
# Whether this key is what we need


def can_find(key):
    try:
        return objects[key]["overrides"]["children"]["USDScene"]["overrides"]["arguments"][2][1]["value"].endswith("card.usdz")
    except:
        return False


def action2config(action):
    return action["__content"][0]["configurations"][0]["__content"][0]["configurationBox"]["configuration"]


def behav2action(behav, action):
    return behav["__content"][0]["actionGroups"][action]


# Note that there's a runtime identifier to be used
good_keys_id = [objects[key]["overrides"]["runtimeAttributes"][0][1]["value"] for key in objects.keys() if can_find(key)]

# This is used to access the content inside the rcproject, not runtime
good_keys = [key for key in objects.keys() if can_find(key)]


# Get orientation data and translation data from the first behavior
# locations = [[-18.805461883544922, -2.7745513916015625, -0.000110626220703125],
#              [39.673583984375, -7.414278984069824, -16.774169921875],
#              [0.23540306091308594, 8.044953346252441, 0.000164031982421875]]

# orientations = [[8.526512829121202e-13,  0.1736510843038559,  -5.936584557275637e-12,  -0.9848071932792664],
#                 [-5.1063850037280645e-08,  -0.3420201241970062,  1.4732336239831056e-07,  -0.9396926164627075],
#                 [4.533262654149439e-12, 5.9117155615240335e-12, -6.650681307757145e-12, -1]]

locations = [action2config(behav2action(behaviors[0], action))["location"] for action in range(1,4)]

orientations = [action2config(behav2action(behaviors[0], action))["orientation"] for action in range(1,4)]

# Update the orientation and translation for all other behaviors
for behav in range(len(good_keys)):
    for action in range(1, 4):
        print(f"Behavior #{behav}, Action #{action}")
        action2config(behav2action(behaviors[behav], action))["orientation"] = orientations[action-1]
        action2config(behav2action(behaviors[behav], action))["location"] = locations[action-1]

# Update the duration of the first action, which is wait in our case
for behav in range(len(good_keys)):
    action2config(behav2action(behaviors[behav], 0))["duration"] = 0.05 * (behav)

for behav in range(len(good_keys)):
    print(action2config(behav2action(behaviors[behav], 0))["duration"])

# The cards are arranged in an upside down order
for index, key in enumerate(good_keys):
    objects[key]["transform"]["matrix"][13] = (len(good_keys) - index - 1) * 0.005

# Redefine the affected objects
for behav in range(len(good_keys_id)):
    for action in range(1, 4):
        action2config(behav2action(behaviors[behav], action))["target"] = [good_keys_id[behav]]

# Write to the rcproject file
with open("com.apple.RCFoundation.Project", "w") as json_file:
    json.dump(json_obj, json_file)
