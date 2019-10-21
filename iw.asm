% Allows easy individual-world practice for Story Mode
% Pressing up/down in the Story Mode level select screen can change the world of the selected file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start of available space gained by removing relocation data in main_loop.rel
% Seems like you can't define functions after it unless it's non-empty
% Also, put constants and global variables here
#function $relSpace 0x279c8c % 0x804e9d8c
0x00000000 % 0x804e9d8c: Frame counter for filename animation
0x00000000 % 0x804e9d90: Boolean, whether we are currently doing an IW
0x46696e69 % 0x804e9d94: "Finish IW"
0x73682049 % 0x804e9d98:
0x57000000 % 0x804e9d9c:
0x436f6e67 % 0x804e9da0: "Congrats on your IW!"
0x72617473 % 0x804e9da4:
0x206f6e20 % 0x804e9da8:
0x796f7572 % 0x804e9dac:
0x20495721 % 0x804e9db0:
0x00000000 % 0x804e9db4: null terminator for "Congrats" message but can also work as empty string
0x446f2079 % 0x804e9db8: "Do your best to try and beat\nthe time, okay?"
0x6f757220
0x62657374
0x20746f20
0x74727920
0x616e6420
0x62656174
0x0a746865
0x2074696d
0x652c206f
0x6b61793f
0x00000000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hook the iw implementation before main_loop calls a function pointer to draw the file select boxes
% Might not be the best choice but probably works for now
#function $hookPoint 0xaeb64 % 0x8031ec64 
b $hookHandle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Where to resume execution after the hook
#function $hookResume 0xaeb68 % 0x8031ec68 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Handles running $main when applicable and returning to after hooked point
#function $hookHandle after $relSpace
% 0x0038 (r30) will be 0x80907914 if file select is currently being drawn
% (it's the address of a non-main_loop function to draw the file select boxes)
% Only run $main if this is true
lis r3, 0x8090
ori r3, r3, 0x7914
lwz r4, 0x0038 (r30)
cmpw r3, r4
bne .return

% Prologue
stwu r1, -0x8 (r1)
mflr r0
stw r0, 0xc (r1)

bl $main

% Epilogue
lwz r0, 0xc (r1)
mtlr r0
addi r1, r1, 0x8

.return
% Run replaced hook instruction and resume at hook point
mr r3, r30
b $hookResume

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#function $main after $relSpace
% Prologue
stwu r1, -0x18 (r1)
mflr r0
stw r0, 0x1c (r1)
stw r31, 0x14 (r1)
stw r30, 0x10 (r1)
stw r29, 0xc (r1)
stw r28, 0x8 (r1)

% Don't change savefile world if savefile not selected
lis r31, 0x8098
ori r31, r31, 0x00ed
lbz r3, 0x0 (r31)
cmpwi r3, 0
bne .handleFilenameAnimation

% Read currently selected file into r3
lbz r3, 0x1 (r31)

% Determine selected save file address (r30)
lis r30, 0x8061
ori r30, r30, 0xcc60
li r29, 132
mullw r29, r29, r3
add r30, r30, r29

% Determine world number for currently selected file (0-10) (r28)
lwz r3, 0x4 (r30)
cmpwi r3, 0
beq .emptySavefile
lbz r28, 0x15 (r30)
b .computedCurrentWorld

.emptySavefile
li r28, 10

.computedCurrentWorld

%% Increase/Decrease world if button pressed
bl $getInput
add r28, r28, r3
cmpwi r28, -1
beq .wrapToEnd
cmpwi r28, 11
beq .wrapToStart
b .afterWrap

.wrapToEnd
li r28, 10
b .afterWrap

.wrapToStart
li r28, 0
b .afterWrap

.afterWrap
mr r3, r30
mr r4, r28
bl $setSavefile

.handleFilenameAnimation
bl $handleFilenameAnimation

% Record whether we're doing an IW (if cursor is focusing an IW savefile)
cmpwi r28, 10
beq .iwSavefileNotFocused
li r3, 1
b .writeIWBool
.iwSavefileNotFocused
li r3, 0
.writeIWBool
lis r4, 0x804e
ori r4, r4, 0x9d90
stw r3, 0x0 (r4)

.end
% Epilogue
lwz r31, 0x14 (r1)
lwz r30, 0x10 (r1)
lwz r29, 0xc (r1)
lwz r28, 0x8 (r1)
lwz r0, 0x1c (r1)
mtlr r0
addi r1, r1, 0x18
blr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#function $handleFilenameAnimation after $relSpace
% Prologue
stwu r1, -0x18 (r1)
mflr r0
stw r0, 0x1c (r1)
stw r31, 0x14 (r1)
stw r30, 0x10 (r1)
stw r29, 0xc (r1)
stw r28, 0x8 (r1)

% Get animation counter
lis r31, 0x804e % r31 = pointer to counter variable
ori r31, r31, 0x9d8c
lwz r30, 0x0 (r31) % r30 = counter value

li r29, 0 % r29 = Current savefile
lis r28, 0x8061
ori r28, r28, 0xcc60 % r28 = current savefile struct pointer

% Loop over savefiles
.savefileLoop

% Decide which animated char to write and write it
cmpwi r30, 3
blt .char0
cmpwi r30, 6
blt .char1
cmpwi r30, 9
blt .char2
b .char3

.char0
li r3, 32 % ' '
stb r3, 0xF (r28)
li r3, 124 % '|'
stb r3, 0x10 (r28)
li r3, 0 % '\0'
stb r3, 0x11 (r28)
b .savefileLoopContinue

.char1
li r3, 47 % '/'
stb r3, 0xF (r28)
li r3, 0 % '\0'
stb r3, 0x10 (r28)
b .savefileLoopContinue

.char2
li r3, 45 % '-'
stb r3, 0xF (r28)
li r3, 0 % '\0'
stb r3, 0x10 (r28)
b .savefileLoopContinue

.char3
li r3, 92 % '\\'
stb r3, 0xF (r28)
li r3, 0 % '\0'
stb r3, 0x10 (r28)
b .savefileLoopContinue

.savefileLoopContinue
addi r29, r29, 1
addi r28, r28, 132 % savefile struct size
cmpwi r29, 3
bne .savefileLoop

% Update counter
addi r30, r30, 1
cmpwi r30, 12
bne .writeCounter
li r30, 0
.writeCounter
stw r30, 0x0 (r31)

.end
% Epilogue
lwz r31, 0x14 (r1)
lwz r30, 0x10 (r1)
lwz r29, 0xc (r1)
lwz r28, 0x8 (r1)
lwz r0, 0x1c (r1)
mtlr r0
addi r1, r1, 0x18
blr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#function $setSavefile after $relSpace
% Prologue
stwu r1, -0x10 (r1)
mflr r0
stw r0, 0x14 (r1)
stw r31, 0xc (r1)
stw r30, 0x8 (r1)

mr r31, r3 % Savefile struct
mr r30, r4 % World to change to

li r4, 132
bl $zeromem

% Make savefile inactive if applicable
cmpwi r30, 10
bne .setWorld
b .end

.setWorld
% Set savefile valid
li r3, 1
stw r3, 0x4 (r31)

% Set world number
stb r30, 0x15 (r31)

% Set name of file
li r3, 87 % 'W'
stb r3, 0x8 (r31)
cmpwi r30, 9
bne .notW10Filename
li r3, 49 % '1'
stb r3, 0x9 (r31)
li r3, 48 % '0'
stb r3, 0xA (r31)
b .doneWritingFilenameWorld
.notW10Filename
li r3, 48 % '0'
stb r3, 0x9 (r31)
li r3, 49 % '1'
add r3, r3, r30
stb r3, 0xA (r31)
.doneWritingFilenameWorld
li r3, 32 % ' '
stb r3, 0xB (r31)
li r3, 73 % 'I'
stb r3, 0xC (r31)
li r3, 87 % 'W'
stb r3, 0xD (r31)
li r3, 32 % ' '
stb r3, 0xE (r31)

.end
% Epilogue
lwz r31, 0xc (r1)
lwz r30, 0x8 (r1)
lwz r0, 0x14 (r1)
mtlr r0
addi r1, r1, 0x10
blr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeroes out memory
% r3: pointer to memory
% r4: bytes to zero
#function $zeromem after $relSpace

% Prologue
stwu r1, -0x18 (r1)
mflr r0
stw r0, 0x1c (r1)
stw r31, 0x14 (r1)
stw r30, 0x10 (r1)
stw r29, 0xc (r1)
stw r28, 0x8 (r1)

mr r31, r3 % r31 = current pointer
mr r30, r4 % r30 = size

mr r29, r3 % r29 = stop pointer
add r29, r29, r4 
li r28, 0

.loop
cmpw r31, r29
bge .endLoop
stw r28, 0x0 (r31)
addi r31, r31, 4
b .loop
.endLoop

% Epilogue
lwz r31, 0x14 (r1)
lwz r30, 0x10 (r1)
lwz r29, 0xc (r1)
lwz r28, 0x8 (r1)
lwz r0, 0x1c (r1)
mtlr r0
addi r1, r1, 0x18
blr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Return 0 if no inputs, 1 if up was pressed, -1 if down was pressed
#function $getInput after $relSpace
% Prologue
stwu r1, -0x8 (r1)
mflr r0
stw r0, 0xc (r1)

.readControlStick
lis r3, 0x8014
ori r3, r3, 0x5300
bl $getBitfieldInput
cmpwi r3, 0
bne .end

.readDpad
lis r3, 0x8014
ori r3, r3, 0x530c
bl $getBitfieldInput

.end
% Epilogue
lwz r0, 0xc (r1)
mtlr r0
addi r1, r1, 0x8
blr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get up/down input from given input bitfield pointer.
% (control stick and dpad values are in same relative positions across bitfields)
% Returns 1 if up, -1 if down, 0 if neither.
#function $getBitfieldInput after $relSpace

% Prologue
stwu r1, -0x10 (r1)
mflr r0
stw r0, 0x14 (r1)
stw r31, 0xc (r1)
stw r30, 0x8 (r1)

% Get control stick / dpad bitfield
lwz r31, 0 (r3)

% Don't count up/down press if left/right is also currently pressed
rlwinm r3, r31, 0, 14, 15
cmpwi r3, 0
beq .checkUp
li r3, 0
b .end

.checkUp
rlwinm r30, r31, 0, 12, 12
cmpwi r30, 0
beq .checkDown
rlwinm r30, r31, 0, 28, 28
cmpwi r30, 0
bne .checkDown
li r3, 1
b .end

.checkDown
rlwinm r30, r31, 0, 13, 13
cmpwi r30, 0
beq .noInputs
rlwinm r30, r31, 0, 29, 29
cmpwi r30, 0
bne .noInputs
li r3, -1
b .end

.noInputs
li r3, 0

.end
% Epilogue
lwz r31, 0xc (r1)
lwz r30, 0x8 (r1)
lwz r0, 0x14 (r1)
mtlr r0
addi r1, r1, 0x10
blr
