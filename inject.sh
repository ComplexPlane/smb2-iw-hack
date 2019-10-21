#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

"$DIR"/../util/ppc-inject/PPCInject "$DIR"/../util/smb2-relmod/mkb2.main_loop_unrelocated.rel "$DIR"/../smb2mut/files/mkb2.main_loop.rel "$DIR"/iw.asm "$DIR"/menutext.asm
"$DIR"/../util/ppc-inject/PPCInject "$DIR"/../smb2imm/files/mkb2.main_game.rel "$DIR"/../smb2mut/files/mkb2.main_game.rel "$DIR"/main_game.asm
