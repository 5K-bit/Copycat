# Lab 05 — Text processing  (about 15 min)

**Goal:** sort, count, slice and compare text with small single-purpose tools.

**Start here:** `cd ~/test-data`

## Steps

1. Sort:
   ```
   sort numbers.txt
   sort -n numbers.txt
   ```
   Compare the two. Plain `sort` is alphabetical, so `100` sorts before `17`.
2. Remove and count duplicates (`uniq` only collapses neighbours, so sort first):
   ```
   sort duplicates.txt | uniq
   sort duplicates.txt | uniq -c
   ```
3. Count:
   ```
   wc -l large-file.txt
   wc -w names.txt
   ```
4. Slice a table:
   ```
   head -n5 employees.csv
   cut -d, -f2,4 employees.csv
   awk -F, 'NR>1 {sum+=$4} END {print sum}' employees.csv
   ```
   `cut -d, -f2,4` keeps columns 2 and 4. The `awk` line adds up the salaries (554000).
5. Compare two files (work in `/tmp` so the seed files stay untouched):
   ```
   cp numbers.txt /tmp/n2.txt
   diff numbers.txt /tmp/n2.txt
   echo 99 >> /tmp/n2.txt
   diff numbers.txt /tmp/n2.txt
   cmp numbers.txt /tmp/n2.txt
   ```
   The first `diff` prints nothing, because the files match.
6. Lines in common between two lists. `users.txt` holds `name:department`, so first cut out
   the name part:
   ```
   head -3 users.txt
   comm -12 <(sort names.txt) <(cut -d: -f1 users.txt | sort)
   ```
   You should see `alice`, `bob` and `charlie`. Try the same `comm` without the `cut` and
   you get nothing: `alice` is not the same line as `alice:Engineering`.

## Check yourself
- What is the median-ish value from `sort -n numbers.txt | head -4 | tail -1`?
- Which department appears most often in `employees.csv`? (Hint: `cut`, `sort`, `uniq -c`, `sort -rn`.)
- Why did `sort duplicates.txt | uniq -c` need the sort?

## Challenge
Print the name and city of everyone in the Engineering department, one per line.

## Done
```
copycat-done 05
```

Broke something? Run `copycat-reset` on your PC (not in here).
