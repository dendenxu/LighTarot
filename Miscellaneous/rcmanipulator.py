import uuid
import copy
import json
import numpy as np
# ? How do we name convenient functions...?

# Load from rcproject file, which is a json file
with open("com.apple.RCFoundation.Project", "rb") as json_file:
    json_obj = json.load(json_file)

# Ease of access
behaviors = json_obj["__content"][0]["scenes"][0]["__content"][0]["behaviors"]
objects = json_obj["__content"][0]["scenes"][0]["__content"][0]["overrides"]["children"]

# From the action to the action's configuration
def action2config(action):
    return action["__content"][0]["configurations"][0]["__content"][0]["configurationBox"]["configuration"]

# From behaviors to its action group
def behav2actionGroup(behav):
    return behav["__content"][0]["actionGroups"]

# From the behavior to a particular action, indexed
def behav2action(behav, action):
    return behav2actionGroup(behav)[action]

# Find all objects with a USDZ file name (using endswith method on path strings)
# Also, returns the runtime identifier, which can be used to bind behaviors to an object
def obj_with_usdz_name(name):
    def has_name(key, name):
        try:
            return objects[key]["overrides"]["children"]["USDScene"]["overrides"]["arguments"][2][1]["value"].endswith(name)
        except:
            return False

    # This is used to access the content inside the rcproject, not runtime
    keys = [key for key in objects.keys() if has_name(key, name)]
    # Note that there's a runtime identifier to be used
    runtime_keys = [objects[key]["overrides"]["runtimeAttributes"][0][1]["value"] for key in keys]
    return keys, runtime_keys

# Find all objects named explicitly in the Reality Composer
# Similarly, the runtime identifier is also returned
def obj_with_name(name):
    def has_name(key, name):
        try:
            my_name = objects[key]["overrides"]["runtimeAttributes"][1][1]["value"]
            # print(f"My name is {my_name}")
            return my_name == name
        except Exception as e:
            # print(e)
            return False
    keys = [key for key in objects.keys() if has_name(key, name)]
    runtime_keys = [objects[key]["overrides"]["runtimeAttributes"][0][1]["value"] for key in keys]
    return keys, runtime_keys

# Pass in a function to determine whether this behavior is what we want to extract
# The function compares the name of the behavior, defined in the reality composer and the named passed by user
def behav_custom_judge(name, func):
    # Return the index (indices) for the behaviors of a specific name
    def has_name(index, name):
        try:
            my_name = behaviors[index]["__content"][0]["name"]
            # print(f"DEBUG: my_name: {my_name}, name: {name}")
            return func(my_name, name)
        except Exception as e:
            # print(e)
            return False

    indices = [i for i in range(len(behaviors)) if has_name(i, name)]
    return indices

# Using equal to compare the two names mentioned above
def behav_with_name(name):
    return behav_custom_judge(name, lambda l, r: l == r)

# Check if the behaviors name starts with a certain string
# "cardOperation 1" starts with "cardOperation"
def behav_starts_with_name(name):
    return behav_custom_judge(name, lambda l, r: l.startswith(r))


file_cards, file_cards_runtime = obj_with_usdz_name("card.usdz")
name_cards, name_cards_runtime = obj_with_name("Card")
name_behavs = behav_starts_with_name("cardOperation")

# Update the last call's relative location, let's first inspect them
# The third of them is the last one
# Here if we use -1, for the first behavior, we'll errornously try to get the location attributes of the "bounce" action
# focused_action = 3 # The focused action in the action group of a behavior
# base_behavior = 0 # The first one is the base here
def update_action_base_on(base_behavior, focused_action):
    new_location = action2config(behav2action(behaviors[name_behavs[base_behavior]], focused_action))["location"]
    new_orientation = action2config(behav2action(behaviors[name_behavs[base_behavior]], focused_action))["orientation"]
    for index in range(len(name_behavs)):
        print(f"Behavior starting with cardOperation, index: {index}")
        print(f"Location: {action2config(behav2action(behaviors[index], focused_action))['location']}")
        print(f"Orientation: {action2config(behav2action(behaviors[index], focused_action))['orientation']}")
        action2config(behav2action(behaviors[index], focused_action))['location'] = new_location
        action2config(behav2action(behaviors[index], focused_action))['orientation'] = new_orientation
        print(f"New location: {action2config(behav2action(behaviors[index], focused_action))['location']}")
        print(f"New orientation: {action2config(behav2action(behaviors[index], focused_action))['orientation']}")
        print("")


action_indices = list(range(1, 4))  # three actions to copy
base_behavior = 0
for index in action_indices:
    print(f"Update action: {index}")
    update_action_base_on(base_behavior, index)

# The orientation array is a quaternion, laying in 4d space, stating the rotation
# I'm guess Apple is is using format [x sin(0), y sin(0), z sin(0), cos(0)], here we use 0 to represent theta
# The y axis is the one actually pointing up
# So our interpolation should like
epsilon = 1e-7
# start_ori = np.array([epsilon, epsilon, epsilon, 1-3*epsilon**2]) # let's just not use a zero starter, avoiding deviding by zero
end_ori = np.array([-1.12839841e-08,  2.58818920e-01, -4.21123740e-08,  9.65925826e-01])
start_ori = np.array([1.12839960e-08, -2.58819193e-01,  4.21124184e-08,  9.65925753e-01])

# pass in a len 4 quaternion
# spits out the theta and the axis
def deform_ori(ori, epsilon=1e-7):
    # epsilon = 1e-7 # a small number should not be used to represent sign
    signs = [1 if abs(e) <= epsilon else (-1 if e < 0 else 1) for e in ori[0:-1]]  # except the last one
    sign = np.prod(signs)
    theta = sign * np.arccos(ori[3])  # Getting the angle, assuming a positive axis, so the orientation can be
    # in the previous example, we should get a -15 degress because we're specifying a -30 degree rotation around the y axis
    the_sin = np.sin(theta)
    axis = ori[0:-1]/the_sin
    return theta * 2, axis

# pass in a theta angle and a 3D axis vector
# spits out a 4D numpy array, quaternion
def form_ori(theta, axis):
    theta /= 2
    return np.concatenate([axis * np.sin(theta), [np.cos(theta)]])


start_theta, start_axis = deform_ori(start_ori, epsilon)  # Overlooking the original axis
end_theta, end_axis = deform_ori(end_ori, epsilon)

# ! Manually defining the starting and ending angle
start_theta = -50 / 180 * np.pi
end_theta = 20 / 180 * np.pi

granularity = len(name_behavs)

for t in np.linspace(start_theta, end_theta, granularity):
    print(f"The angle to rotate around the axis {end_axis} is: {t}")
    print(f"The quaternion formed by it is: {form_ori(t, end_axis)}")

# Interpolate the new actions
new_orientation = [form_ori(t, end_axis) for t in np.linspace(start_theta, end_theta, granularity)]
focused_action = 3
for index in name_behavs:
    # Note that numpy array is not JSON serializable
    action2config(behav2action(behaviors[index], focused_action))['orientation'] = list(new_orientation[index])

# compute a circle from three points on the plane
# here we should eliminate Y axis' value
# Eventually we used complex number to perform the computation
start_location = np.array([-40, 0, -5], dtype="double")
middle_location = np.array([-20, 0, 10], dtype="double")
end_location = np.array([0, 0, 5], dtype="double")

theY = start_location[1]

x, y, z = start_location[0] + start_location[2]*1j, middle_location[0] + middle_location[2]*1j, end_location[0] + end_location[2]*1j

# from three points on the complex plane, gives a center and a radius
def form_circle(x, y, z):
    w = z-x
    w /= y-x
    c = (x-y)*(w-abs(w)**2)/2j/w.imag-x
    return -c, abs(c+x)

# Get the coordinate around a circle
# a: angle, starting from right direction
# c: center of the circle
# r: radius of the circle
def around_circle(a, c, r):
    return r*(np.cos(a) + np.sin(a)*1j) + c


c, r = form_circle(x, y, z)

for a in np.linspace(0, np.pi * 2, 100):
    print(around_circle(a, c, r))

# from two points, construct the angle rotated
start_angle = np.arctan2((x-c).imag, (x-c).real)
end_angle = np.arctan2((z-c).imag, (z-c).real)

new_locations = [around_circle(t, c, r) for t in np.linspace(start_angle, end_angle, granularity)]
new_locations = [[n.real, theY, n.imag] for n in new_locations]
focused_action = 3
for index in name_behavs:
    # Note that numpy array is not JSON serializable
    action2config(behav2action(behaviors[index], focused_action))['location'] = new_locations[index]

# Get orientation data and translation data from the first behavior
# locations = [[-18.805461883544922, -2.7745513916015625, -0.000110626220703125],
#              [39.673583984375, -7.414278984069824, -16.774169921875],
#              [0.23540306091308594, 8.044953346252441, 0.000164031982421875]]

# orientations = [[8.526512829121202e-13,  0.1736510843038559,  -5.936584557275637e-12,  -0.9848071932792664],
#                 [-5.1063850037280645e-08,  -0.3420201241970062,  1.4732336239831056e-07,  -0.9396926164627075],
#                 [4.533262654149439e-12, 5.9117155615240335e-12, -6.650681307757145e-12, -1]]
# locations = [action2config(behav2action(behaviors[0], action))["location"] for action in range(1, 4)]
# orientations = [action2config(behav2action(behaviors[0], action))["orientation"] for action in range(1, 4)]
# # Update the orientation and translation for all other behaviors
# for behav in range(len(name_cards)):
#     for action in range(1, 4):
#         print(f"Behavior #{behav}, Action #{action}")
#         action2config(behav2action(behaviors[behav], action))["orientation"] = orientations[action-1]
#         action2config(behav2action(behaviors[behav], action))["location"] = locations[action-1]
# Update the duration of the first action, which is wait in our case
for behav in name_behavs:
    action2config(behav2action(behaviors[behav], 0))["duration"] = 0.05 * (behav)
    print(action2config(behav2action(behaviors[behav], 0))["duration"])

# The cards are arranged in an upside down order
for index, key in enumerate(name_cards):
    objects[key]["transform"]["matrix"][13] = \
        (len(name_cards) - index - 1) * 0.0005
    # index * 0.0005

# Redefine the affected objects
for behav in range(len(name_cards_runtime)):
    for action in range(1, 4):
        action2config(behav2action(behaviors[behav], action))["target"] = [name_cards_runtime[behav]]

for index, key in enumerate(objects.keys()):
    try:
        print(objects[key]["transform"]["matrix"])
    except:
        continue


# Generate upper case uuid version 4, which is used
# in swift and Reality Composer to identify objects
def upuuid():
    return str(uuid.uuid4()).upper()

# index: current action index in behavior chain
# the_action: the action to be updated
# Passed by reference, changes are made in place, so maybe we want to make a copy first
def change_duration(index, the_action):
    action2config(the_action)["duration"] = 0.05 * (len(name_behavs) - index - 1)

# Similarly, but this time we update the newly added actions' transform
def change_transform(index, the_action):
    action2config(the_action)["location"] = [0, 10, 0]
    action2config(the_action)["orientation"] = [0, 0, 0, 1]

# Insert an action to all the named_behaviors
def insert_in_place(src, dst, func):
    for index in name_behavs:
        print(f"length of behavior #{index} before insertion: {len(behav2actionGroup(behaviors[index]))}")  # get all the action group concerning this problem
        the_action = copy.deepcopy(behav2action(behaviors[index], src))  # the first waiting action
        the_action["__content"][0]["identifier"] = upuuid()
        the_action["__content"][0]["configurations"][0]["__content"][0]["identifier"] = upuuid()
        func(index, the_action)
        print(the_action)
        behav2actionGroup(behaviors[index]).insert(dst, the_action)
        print(f"length of behavior #{index} after insertion: {len(behav2actionGroup(behaviors[index]))}")  # get all the action group concerning this problem


# insert_in_place(0, 4, change_duration)
# insert_in_place(1, 5, change_transform)

def do_nothing(index, dst_action):
    pass

def insert_action(src_aciton, dst, func, behavs, cards):
    for index in behavs:
        print(f"length of behavior #{index} before insertion: {len(behav2actionGroup(behaviors[index]))}")  # get all the action group concerning this problem
        dst_action = copy.deepcopy(src_aciton)
        # for all possible target settings
        dst_action["__content"][0]["identifier"] = upuuid()
        for config in dst_action["__content"][0]["configurations"]:
            config["__content"][0]["identifier"] = upuuid()
            if "target" in config["__content"][0]["configurationBox"]["configuration"]:
                # Possibly no target at all!
                config["__content"][0]["configurationBox"]["configuration"]["target"] = [cards[index]]
        func(index, dst_action)
        behav2actionGroup(behaviors[index]).insert(dst, dst_action)
        print(f"length of behavior #{index} after insertion: {len(behav2actionGroup(behaviors[index]))}")  # get all the action group concerning this problem

shuffle_behavs = behav_starts_with_name("shuffleOperation")
first_shuffle_actions = behav2actionGroup(behaviors[shuffle_behavs[0]])
for action in first_shuffle_actions:
    insert_action(action, 0, do_nothing, name_behavs, name_cards_runtime) # Should use runtime identifiers


# MARK: Write to the rcproject file
with open("com.apple.RCFoundation.Project", "w") as json_file:
    json.dump(json_obj, json_file)
