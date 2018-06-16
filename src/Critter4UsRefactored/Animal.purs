module Critter4UsRefactored.Animal
  ( Animal
  , Id
  , Tags
  , named
  )
  where

type Id = Int
type Tags = Array String

type Animal =
  { id :: Id
  , name :: String
  }

named :: String -> Id -> Animal
named name id =
  { id, name }

