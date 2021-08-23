{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "lenses"
, dependencies =
  [ "colors"
  , "console"
  , "effect"
  , "prelude"
  , "profunctor-lenses"
  , "psci-support"
  , "random"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
