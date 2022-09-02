# tents-and-trees-puzzle-solver
An automated solver for the Tents puzzle in Scheme. You can play the game online [here](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/tents.html)

Places tents in the empty squares in such a way that:
1. No two tents are adjacent, even diagonally.
2. The number of tents in each row and column matches the numbers
around the edge of the grid.
3. It is possible to match tents to trees so that each tree is horizontally or
vertically adjacent to its own tent (but may also be adjacent to other
tents that are matched with other trees).

Program returns the solution for a given tents puzzle or returns false if there are no solutions. In case there are multiple valid solutions for the given puzzle only one solution is shown. 

### Input & Output

Input format:
``` 
( (<tent-count-row1> ... <tent-count-rowN>)
(<tent-count-column1> ... <tent-count-columnM>)
( (<tree1-x> <tree1-y>) ... (<treeT-x> <treeT-y>) ) )
```

Output format:
```
( (<tents1-x> <tents1-y>) ... (<tentsT-x> <tentsT-y>) )
````

Puzzle Example: 

<img width="347" alt="Screen Shot 2022-09-02 at 09 39 17" src="https://user-images.githubusercontent.com/48058901/188074398-a667976d-4b50-4f29-b862-d5c1b834fb05.png">

example input:
```
'( (2 1 3 1 3 1 1 0)
(1 2 1 3 0 2 1 2)
( (1 3) (1 6) (2 4) (2 8) (3 2) (3 5) (4 3) (4 6) (5 7) (6 4) (7 1) (8 3) ) )
```
example output:
```
((7 3) (6 1) (5 4) (5 8) (5 6) (4 2) (3 6) (2 2) (3 8) (3 4) (1 7) (1 4))
```

The program is implemented in pure functional programming style. ie there are not: <br>
• Any function or language element that ends with an !.<br>
• Any of these constructs: begin, begin0, when, unless, for, for*, do, loop,set!-values, let. <br>
• Any language construct that starts with for/ or for*/.<br>
• Any construct that causes any form of mutation (impurity).<br>

<i> Developed for CMPE 260 Principles of Programming Languages course, Bogazici University Computer Engineering, Spring 2020. <i>

