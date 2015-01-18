module Turing where

import           Data.Foldable (toList)
import qualified Data.List as L
import qualified Data.Sequence as Seq
import           Data.Sequence (Seq, (<|), (|>), ViewL (..), ViewR(..))

type State = Int
type Symbol = Char

-- | Tape head movement direction.
data Direction = MoveLeft | MoveRight

data Machine = Machine {
  -- | @'transition' s smb@ defines the behaviour of the machine when it
  -- is in state @s@ and @smb@ is the symbol under the tape head.
  -- The function returns the next state of the machine,
  -- the symbol overwriting the current symbol under the tape head,
  -- and the direction in which the tape head should move after overwriting.
  --
  -- If @smb@ is @'Just' x@, that signifies that @x@ is the current symbol
  -- under the tape head.
  -- If @smb@ is 'Nothing', that means that the tape head is over a
  -- tape position that has not been initialised yet.
  transition :: State -> Maybe Symbol -> (State, Symbol, Direction)

, startState, acceptState, rejectState :: State
}

data TapeCfg = TapeCfg {
  leftSyms  :: Seq Symbol    -- ^ symbols to the left of tape head
, currSym   :: Maybe Symbol  -- ^ symbol under the tape head
, rightSyms :: Seq Symbol    -- ^ symbols to the right of tape head
}

data MachineCfg = MachineCfg {
  currState :: State
, tapeCfg :: TapeCfg
}

instance Show TapeCfg where
  show (TapeCfg l c r) = toList l ++ [maybe ' ' id c] ++ toList r

instance Show MachineCfg where
  show (MachineCfg s t) =
    show t ++ "\n" ++ replicate (Seq.length $ leftSyms t) ' ' ++ "| q" ++ show s
  showList = showString . L.intercalate "\n\n" . map show

-- | Replace symbol under tape head with new symbol, then move tape head.
updateTapeCfg :: TapeCfg -> Symbol -> Direction -> TapeCfg
updateTapeCfg (TapeCfg lSyms _ rSyms) newSym MoveLeft =
  case Seq.viewr lSyms of EmptyR -> TapeCfg Seq.empty Nothing right
                          lInit :> lLast -> TapeCfg lInit (Just lLast) right
  where right = newSym <| rSyms
updateTapeCfg (TapeCfg lSyms _ rSyms) newSym MoveRight =
  case Seq.viewl rSyms of EmptyL -> TapeCfg left Nothing Seq.empty
                          rHead :< rTail -> TapeCfg left (Just rHead) rTail
  where left = lSyms |> newSym

-- | Execute one transition step for given machine and config.
updateMachineCfg :: Machine -> MachineCfg -> MachineCfg
updateMachineCfg m (MachineCfg state tape) =
  let (state', newSym, dir) = transition m state (currSym tape)
  in MachineCfg state' $ updateTapeCfg tape newSym dir

-- | Initialise tape with input word.
initTapeCfg :: [Symbol] -> TapeCfg
initTapeCfg [] = TapeCfg Seq.empty Nothing Seq.empty
initTapeCfg (x:xs) = TapeCfg Seq.empty (Just x) (Seq.fromList xs)

-- | Initialise machine config with input word.
initMachineCfg :: Machine -> [Symbol] -> MachineCfg
initMachineCfg m input = MachineCfg (startState m) (initTapeCfg input)

-- | Return true if the machine is in a final state.
machineCfgFinal :: Machine -> MachineCfg -> Bool
machineCfgFinal m (MachineCfg {currState = c}) =
  c == acceptState m ||
  c == rejectState m

-- | Return sequence of machine configs for given input word until final state.
runMachine :: Machine -> [Symbol] -> [MachineCfg]
runMachine m =
  break' (machineCfgFinal m) . iterate (updateMachineCfg m) . initMachineCfg m
  where
    -- | Like 'break', but also return first element that fulfills condition
    break' p xs = let (prefix, rest) = break p xs in prefix ++ [head rest]

-- | A Turing machine accepting all input.
testMachine :: Machine
testMachine =
  Machine { transition = t
          , startState = 0
          , acceptState = 2
          , rejectState = 3} where

  t 0 (Just x) = (0,   x, MoveRight)
  t 0 Nothing  = (1, 'E', MoveLeft)
  t 1 (Just x) = (1,   x, MoveLeft)
  t 1 Nothing  = (2, 'S', MoveRight)


main = print $ runMachine testMachine "10011"
