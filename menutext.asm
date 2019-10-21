% Responsible for patching menus and text related to the IW. This includes:
% - Exiting game on "Stage select" upon completing the final stage of the world
% - Making "Stage select" text "Finish IW" upon completing the final stage of the world
% - Modifying the exit game scrolling text when finishing an IW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#function $stageSelectMenuHookPoint 0x4704 % 0x80274804
b $stageSelectMenuHook

#function $stageSelectMenuHook after $relSpace
stwu r1, -0x38 (r1)
stw r31, 0x34 (r1)
stw r30, 0x30 (r1)
stw r29, 0x2c (r1)
stw r28, 0x28 (r1)
stw r27, 0x24 (r1)
stw r26, 0x20 (r1)
stw r25, 0x1c (r1)
stw r24, 0x18 (r1)
stw r23, 0x14 (r1)
stw r22, 0x10 (r1)
stw r21, 0xc (r1)
mr r31, r12
mr r30, r11
mr r29, r10
mr r28, r9
mr r27, r8
mr r26, r7
mr r25, r6
mr r24, r5
mr r23, r4
mr r22, r3
mr r21, r0

bl $isIWComplete
cmpwi r3, 1
bne .iwNotComplete
% Jump to "Exit game" handler
lis r4, 0x8027
ori r4, r4, 0x48cc
mtlr r4
b .end

% Resume "Stage select" handler
.iwNotComplete
lis r4, 0x8027
ori r4, r4, 0x4808
mtlr r4
li r21, 6 % Replaced instruction was "li r0, 6"

.end
mr r12, r31 
mr r11, r30 
mr r10, r29 
mr r9, r28 
mr r8, r27 
mr r7, r26 
mr r6, r25 
mr r5, r24 
mr r4, r23 
mr r3, r22 
mr r0, r21 
lwz r31, 0x34 (r1)
lwz r30, 0x30 (r1)
lwz r29, 0x2c (r1)
lwz r28, 0x28 (r1)
lwz r27, 0x24 (r1)
lwz r26, 0x20 (r1)
lwz r25, 0x1c (r1)
lwz r24, 0x18 (r1)
lwz r23, 0x14 (r1)
lwz r22, 0x10 (r1)
lwz r21, 0xc (r1)
addi r1, r1, 0x38
blr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#function $pauseMenuTextHookPoint 0xba76c % 0x8032a86c
b $pauseMenuTextHook

#function $pauseMenuTextHookResume 0xba770 % 0x8032a870

#function $pauseMenuTextHook after $relSpace
stwu r1, -0x38 (r1)
stw r31, 0x34 (r1)
stw r30, 0x30 (r1)
stw r29, 0x2c (r1)
stw r28, 0x28 (r1)
stw r27, 0x24 (r1)
stw r26, 0x20 (r1)
stw r25, 0x1c (r1)
stw r24, 0x18 (r1)
stw r23, 0x14 (r1)
stw r22, 0x10 (r1)
stw r21, 0xc (r1)
mr r31, r12
mr r30, r11
mr r29, r10
mr r28, r9
mr r27, r8
mr r26, r7
mr r25, r6
mr r24, r5
mr r23, r4
mr r22, r3
mr r21, r0

bl $isIWComplete
cmpwi r3, 1
bne .dontModifyText

% Check if we're trying to draw the "Stage select" string
lwzx r3, r25, r21 % Load pointer to string like in replaced instruction
lis r4, 0x8047
ori r4, r4, 0xf02c
cmpw r3, r4
bne .dontModifyText

% Replace pointer with pointer to our custom text
lis r23, 0x804e
ori r23, r23, 0x9d94
b .end

% Show current menu text like normal
.dontModifyText
lwzx r23, r25, r21 % Analog of replaced instruction

.end
mr r12, r31 
mr r11, r30 
mr r10, r29 
mr r9, r28 
mr r8, r27 
mr r7, r26 
mr r6, r25 
mr r5, r24 
mr r4, r23 
mr r3, r22 
mr r0, r21 
lwz r31, 0x34 (r1)
lwz r30, 0x30 (r1)
lwz r29, 0x2c (r1)
lwz r28, 0x28 (r1)
lwz r27, 0x24 (r1)
lwz r26, 0x20 (r1)
lwz r25, 0x1c (r1)
lwz r24, 0x18 (r1)
lwz r23, 0x14 (r1)
lwz r22, 0x10 (r1)
lwz r21, 0xc (r1)
addi r1, r1, 0x38
b $pauseMenuTextHookResume

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%#function $exitGameText1HookPoint 0xb9ee8 % 0x80329fe8
%b $exitGameText1Hook
%
%#function $exitGameText1HookResume 0xb9eec % 0x80329fec
%
%#function $exitGameText1Hook after $relSpace
%stwu r1, -0x38 (r1)
%stw r31, 0x34 (r1)
%stw r30, 0x30 (r1)
%stw r29, 0x2c (r1)
%stw r28, 0x28 (r1)
%stw r27, 0x24 (r1)
%stw r26, 0x20 (r1)
%stw r25, 0x1c (r1)
%stw r24, 0x18 (r1)
%stw r23, 0x14 (r1)
%stw r22, 0x10 (r1)
%stw r21, 0xc (r1)
%mr r31, r12
%mr r30, r11
%mr r29, r10
%mr r28, r9
%mr r27, r8
%mr r26, r7
%mr r25, r6
%mr r24, r5
%mr r23, r4
%mr r22, r3
%mr r21, r0
%
%bl $isIWComplete
%cmpwi r3, 1
%bne .end
%
%.handleFirstLine
%% Check whether we're handling the first text line of the exit game box
%lis r3, 0x804c
%ori r3, r3, 0x44f4
%cmpw r3, r23
%bne .handleSecondLine
%lis r23, 0x804e
%ori r23, r23, 0x9da0
%b .end
%
%.handleSecondLine
%% Check whether we're handling the second line of text
%lis r3, 0x804c
%ori r3, r3, 0x45e4
%cmpw r3, r23
%bne .end
%lis r23, 0x804e
%ori r23, r23, 0x9db4
%
%.end
%lis r22, 0x805f % Analog of replaced instruction
%mr r12, r31 
%mr r11, r30 
%mr r10, r29 
%mr r9, r28 
%mr r8, r27 
%mr r7, r26 
%mr r6, r25 
%mr r5, r24 
%mr r4, r23 
%mr r3, r22 
%mr r0, r21 
%lwz r31, 0x34 (r1)
%lwz r30, 0x30 (r1)
%lwz r29, 0x2c (r1)
%lwz r28, 0x28 (r1)
%lwz r27, 0x24 (r1)
%lwz r26, 0x20 (r1)
%lwz r25, 0x1c (r1)
%lwz r24, 0x18 (r1)
%lwz r23, 0x14 (r1)
%lwz r22, 0x10 (r1)
%lwz r21, 0xc (r1)
%addi r1, r1, 0x38
%b $exitGameText1HookResume

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%#function $exitGameText2HookPoint 0x16cc18 % 0x803dcd18
%b $exitGameText2Hook
%
%#function $exitGameText2HookResume 0x16cc1c % 0x803dcd1c
%
%#function $exitGameText2Hook after $relSpace
%stwu r1, -0x38 (r1)
%stw r31, 0x34 (r1)
%stw r30, 0x30 (r1)
%stw r29, 0x2c (r1)
%stw r28, 0x28 (r1)
%stw r27, 0x24 (r1)
%stw r26, 0x20 (r1)
%stw r25, 0x1c (r1)
%stw r24, 0x18 (r1)
%stw r23, 0x14 (r1)
%stw r22, 0x10 (r1)
%stw r21, 0xc (r1)
%mr r31, r12
%mr r30, r11
%mr r29, r10
%mr r28, r9
%mr r27, r8
%mr r26, r7
%mr r25, r6
%mr r24, r5
%mr r23, r4
%mr r22, r3
%mr r21, r0
%
%% Analog of replaced instruction
%lwzx r23, r23, r21
%
%% Check if IW completed
%bl $isIWComplete
%cmpwi r3, 1
%bne .end
%
%% Replace string pointer to second text page's string with ours if that's what this function is handling
%lis r3, 0x804c
%ori r3, r3, 0x46b0
%cmpw r3, r23
%bne .end
%lis r23, 0x804e
%ori r23, r23, 0x9db8
%
%.end
%mr r12, r31 
%mr r11, r30 
%mr r10, r29 
%mr r9, r28 
%mr r8, r27 
%mr r7, r26 
%mr r6, r25 
%mr r5, r24 
%mr r4, r23 
%mr r3, r22 
%mr r0, r21 
%lwz r31, 0x34 (r1)
%lwz r30, 0x30 (r1)
%lwz r29, 0x2c (r1)
%lwz r28, 0x28 (r1)
%lwz r27, 0x24 (r1)
%lwz r26, 0x20 (r1)
%lwz r25, 0x1c (r1)
%lwz r24, 0x18 (r1)
%lwz r23, 0x14 (r1)
%lwz r22, 0x10 (r1)
%lwz r21, 0xc (r1)
%addi r1, r1, 0x38
%b $exitGameText2HookResume

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#function $isIWComplete after $relSpace

% Check that we're not in Practice Mode
lis r3, 0x805d
ori r3, r3, 0x4914
lwz r4, 0x0 (r3)
cmpwi r4, 1
beq .no

% Check if we're doing an IW
lis r3, 0x804e
ori r3, r3, 0x9d90
lwz r4, 0x0 (r3)
cmpwi r4, 1
bne .no

% Check if 9 stages in world complete

%% Get current world number
lis r3, 0x8054
ori r3, r3, 0xdbb8
lhz r4, 0x4 (r3)

%% Get current number of stages beaten in world from world number
lis r5, 0x805d
ori r5, r5, 0x4b08
mulli r4, r4, 56
add r5, r5, r4
lhz r6, 0x2 (r5)
cmpwi r6, 9
bne .no

% Check if current stage complete
lis r3, 0x8054
ori r3, r3, 0xdc83
lbz r4, 0x0 (r3)
cmpwi r4, 1
bne .no

li r3, 1
b .end

.no
li r3, 0

.end
blr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if savefile is active and named /W.. IW/
% Not useful right now
#function $isSavefileAnIW after $relSpace
% Prologue
stwu r1, -0x10 (r1)
mflr r0
stw r0, 0x14 (r1)
stw r31, 0xc (r1)
stw r30, 0x8 (r1)

mr r31, r3 % r31 = savefile struct pointer

% Check if active
lwz r30, 0x4 (r31)
cmpwi r30, 0
beq .no

% Check savefile filename
lbz r30, 0x8 (r31)
cmpwi r30, 87 % 'W'
bne .no
lbz r30, 0xB (r31)
cmpwi r30, 32 % ' '
bne .no
lbz r30, 0xC (r31)
cmpwi r30, 73 % 'I'
bne .no
lbz r30, 0xD (r31)
cmpwi r30, 87 % 'W'
bne .no

.yes
li r3, 1
b .end

.no
li r3, 0

.end
% Epilogue
lwz r31, 0xc (r1)
lwz r30, 0x8 (r1)
lwz r0, 0x14 (r1)
mtlr r0
addi r1, r1, 0x10
blr

