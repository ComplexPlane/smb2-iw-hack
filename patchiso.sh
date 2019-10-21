#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
main_loop_path="$DIR"/../smb2mut/files/mkb2.main_loop.rel 
main_game_path="$DIR"/../smb2mut/files/mkb2.main_game.rel
sel_ngc_path="$DIR"/../smb2mut/files/mkb2.sel_ngc.rel
isopath="$DIR"/../smb2mut.iso

dd if="$main_loop_path" of="$isopath" seek=1444408292 conv=notrunc oflag=seek_bytes
dd if="$main_game_path" of="$isopath" seek=520270084 conv=notrunc oflag=seek_bytes
dd if="$sel_ngc_path" of="$isopath" seek=1436267024 conv=notrunc oflag=seek_bytes
