import Control.Applicative (pure)
import Control.Monad.Omega (Omega, each, runOmega)
import Data.Set (Set, (\\), fromList)

type     Rule = [Atom]
type Variable = [Rule]

data Atom = T Char | V Variable

lang :: Atom -> Omega String
lang (T t) = return [t]
lang (V rules) = do
  rule <- each rules
  word <- mapM lang rule
  return $ concat word

langO :: Atom -> [String]
langO = runOmega . lang


langDiff :: Atom -> Atom -> (Set String, Set String)
a1 `langDiff` a2 =
  (fromList (take few l1) \\ fromList (take many l2),
   fromList (take few l2) \\ fromList (take many l1))
  where l1 = langO a1
        l2 = langO a2
        few = 50
        many = few * 100


-- -----------------------------------------------------------------------------
-- Grammars

-- terminals
tx, tp, t0, t1 :: Atom
tx = T 'x'
tp = T '+'
t0 = T '0'
t1 = T '1'

-- my solution
vsum, vtok, vbool, vbool' :: Atom
vsum = V [pure vtok, [vsum, tp, vsum]]       -- S -> T | S + S
vtok = V [pure tx, pure vbool]               -- T -> x | B
vbool  = V [pure t0, [t1, vbool']]           -- B -> 0 | 1C
vbool' = V [[], [t0, vbool'], [t1, vbool']]  -- C -> ε | 0C | 1C

{- student solution 1
vs = V [pure vt, pure tx, [tx, vm], [t0, vm], pure t0, pure t1]
vt = V [[t1, va], [t1, vt], [t1, vm]]
vm = V [[tp, vt], [tp, vs]]
va = V [[va, va], pure vm, pure t0, [t0, vt]]
-}

{- student solution 2
vs = V [pure tx, pure t1, pure vx]
vx = V [pure t1, pure tx, [vx, vy, vz], [vx, vx]]
vy = V [[], pure tp, pure t1, pure t0]
vz = V [[], pure t0, pure t1, pure tx, [vz, vz]]
-}

{- student solution 3
vv = V [pure vy, pure vz]
vy = V [pure t0, pure t1, [t1, vy], [t1, t0, vy], [t0, tp, vv], [t1, tp, vv]]
vz = V [pure tx, [tx, tp, vv]]
-}

{- simple test grammar
vx = V [[T 'a'], [T 'a', vx]]  -- X -> a | aX
vy = V [[T 'b', vx]]           -- Y -> bX
vz = V [[vx], [vy]]            -- Z -> X | Y
-}


-- -----------------------------------------------------------------------------
-- Main

main = print $ take 20 $ langO vsum
