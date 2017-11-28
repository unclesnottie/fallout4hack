# FalloutHacker

This application attempts to help you with the hacking mini-game that is featured
in the Fallout game series.  

This mini-game essentially gives you a list of possible passwords and four tries
to guess the password. An incorrect guess will give  likeness score which is the
number of characters that match. If all four tries get used, the terminal becomes
locked permanently.  I highly recommend you quick save before hacking.

This application allows you to enter all the passwords separated by spaces.
It will show an error if the words are not all the same length.  If they are the
same length, then it will give a "best" guess for you to try.  You are then
prompted for the likeness score for your guess.  This repeats until the password
is found.

## Example
```
  $ bin/run

  Enter possible passwords:  foo bar baz
  Your best guess is "BAR".
  Enter likeness:  2
  The password is "BAZ".
```

## The Algorithm

The algorithm for finding a password is pretty basic.   Each word is given a
score by calculating the likeness with all words in the list. For example, `FOO`
would get scores of `[3, 0, 0]`. The final score for a word is the number of
unique likenesses.  `FOO` has the unique likenesses of `[3, 0]` or a score of `2`.
The final scores for each word would be: `FOO=2, BAR=3, BAZ=3`. The "best" guess
returned is the result with the highest score.

Once a likeness is provided, the list of possible passwords gets filtered and the
password or a new "best" guess is returned.  

I put "best" in quotes because there are better algorithms to use but this one is
simple and generally works.  Upgrade your hacking perk and remember to quick save
and this should work just fine.
