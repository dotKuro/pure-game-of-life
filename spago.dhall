{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies = [ 
    "effect"
  , "p5"
  , "psci-support"
  , "random"
  , "test-unit"
  , "web-html" 
  ] 
, packages = ./packages.dhall 
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
