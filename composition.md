# A catalog of compositions {#compositions}

## `Lens <<<` *optic*

{width="wide"}
| Type appended | Example         | Result type                                       | Notes  |
|---------------|-----------------|---------------------------------------------------|--------|
| `Lens`        | `_1 <<< _1`     | `Lens' (Tuple (Tuple a _1_) _2_) a`               |        |
|---------------|-----------------|---------------------------------------------------|--------|
| `At` lens     | `_1 <<< at 1`   | `At keyed Int a =>`                              |        |
|               |                 | `Lens' (Tuple keyed _2_) (Maybe a)`              |   1    |
|               |                 | (An `At` lens)                                    |        |
|---------------|-----------------|---------------------------------------------------|--------|
| `Traversal`   | `_1 <<< traversed` | `Traversable trav =>`                          |        |
|               |                    | `Traversal' (Tuple (trav a) _1_) a`            |        |
|               |                    | ``                                    |        |
|---------------|-----------------|---------------------------------------------------|--------|

1. Use `traversed` or `_Just` to convert the resulting `At` lens to a `Traversal`:

   ```
   _1 <<< at 1 <<< traversed
   ```

## `At` lens `<<<` *optic*


The only optic that can be added after an `At` lens is a something that turns it into a `Traversal`.

{width="wide"}
| Type appended          | Example         | Result type                            |    Notes |
|---------------|-----------------|----------------|-------------------------------------------|
| `Traversal`   | `at 1 <<< traversed` | `At keyed Int a =>`                        |          |
|               |                      | `Traversal' keyed a`                       |          |
|               |                      |                                            |          |
|---------------|-----------------|----------------|-------------------------------------------|
| `Prism`       | `at 1 <<< _Just`     | `At keyed Int a =>`                        |          |
|               |                      | `Traversal' keyed a`                       |          |
|               |                      |                                            |          |
|---------------|-----------------|----------------|-------------------------------------------|



## `Traversal` `<<<` *optic*


{width="wide"}
| Type appended          | Example         | Result type                            |    Notes |
|---------------|-----------------|----------------|-------------------------------------------|
| `Traversal`   | `traversed <<< traversed` | `Traversable trav1 => Traversable trav2`  |      |
|               |                           | `Traversal (trav1 (trav2 a))`         |          |
|               |                           | `          (trav1 (trav2 b))`         |          |
|               |                           | `          a b              `         |          |
|---------------|-----------------|----------------|-------------------------------------------|
| `At` lens     | `traversed <<< at 3`      | `Traversable trav => At keyed Int a =>` |        |
|               |                           | `Traversal' (trav keyed) (Maybe a)`     |   1       |
|---------------|-----------------|----------------|-------------------------------------------|
| `Lens`        | `traversed <<< _1`        | `Traversable trav => `                        |          |
|               |                           | `Traversal (trav (Tuple a _1_))`                        |          |
|               |                           | `          (trav (Tuple b _1_))`                        |          |
|               |                           | `          a b`                        |          |
|---------------|-----------------|----------------|-------------------------------------------|



|               |                           | ``                        |          |
