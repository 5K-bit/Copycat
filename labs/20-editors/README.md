# Lab 20 — Text editors  (about 15 min)

**Goal:** open, edit, save and quit in `nano` and `vi` without getting stuck.

**Start here:** `cd ~`

## Steps: nano (the friendly one)

1. Open a new file:
   ```
   nano ~/notes-20.txt
   ```
2. Type a couple of lines. The shortcuts are listed along the bottom (`^` means Ctrl):
   - `Ctrl+O` then Enter: save
   - `Ctrl+W`: search
   - `Ctrl+K` / `Ctrl+U`: cut a line / paste it
   - `Ctrl+X`: exit (it asks to save if you did not)
3. Prove it was saved:
   ```
   cat ~/notes-20.txt
   ```

## Steps: vi (it is on every server)

`vi` has **modes**. You start in *normal* mode, where keys are commands, not text.

4. Open the same file:
   ```
   vi ~/notes-20.txt
   ```
5. Insert text: press `i`, type a line, then press `Esc` to go back to normal mode.
6. Save and quit: type `:wq` and press Enter.
7. Open it again, press `i`, type junk, press `Esc`, then quit WITHOUT saving: `:q!` and Enter.
   Check with `cat` that the junk is not there.
8. Other useful moves (in normal mode): `dd` deletes a line, `u` undoes, `/word` searches,
   `gg` jumps to the top, `G` to the bottom, `x` deletes a character.

## Steps: choosing an editor

9. Programs like `crontab -e` use `$EDITOR`:
   ```
   echo $EDITOR
   ```
   It is set to `nano` here. Run `EDITOR=vi crontab -e` to see the other one, then leave
   without saving.

## Check yourself
- How do you quit `vi` if you changed nothing? If you changed something and want to keep it?
- What is the difference between `Ctrl+X` and `Ctrl+O` in nano?
- Why did typing `hello` in `vi` right after opening it do something strange?

## Challenge
Add a line to `~/Documents/todo.txt` using `vi`, then confirm with `tail -1`.

## Done
```
copycat-done 20
```

Broke something? Run `copycat-reset` on your PC (not in here).
