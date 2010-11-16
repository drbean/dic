module FirstLast
	where
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr
import qualified Text.ParserCombinators.Parsec.Token as Token
import Text.ParserCombinators.Parsec.Language

unclozeables = [ "Chris", "Elizabeth", "beforehand", "celebrities", "drop any names", "Celebrity question" ]

text = "Celebrity question\n\n02:40 Chris: Now first of all, you have a number of questions, as we talked about beforehand, that people always ask you.\n02:46 Some of which you can answer, and some of which you can't.\n02:48 So let's start with those to just get those out of the way.\n02:51 Elizabeth: Okay. Everybody asks me, when I do a tour at Walt Disney World, and it's a VIP tour...\n02:57 They always say, Well, tell me, who have you taken around? What are the celebrities like when you take them on the rides?\n03:03 And, yes, I have hosted celebrities, athletes and things like that.\n03:06 But, tour guides, they find that these guests are just like you and I and they experience the park and enjoy it just like we all do.\n03:13 So they have fun moments and exciting moments out in the park just like you and I.\n03:18 But I'm not here to drop any names or anything like that.\n\n"

lexer :: Token.TokenParser ()
lexer = Token.makeTokenParser emptyDef{ reservedNames = unclozeables }
myreserved :: String -> Parser String
myreserved string = do { reserved string; return string }
mysymbol :: String -> Parser String
mysymbol string = do { x <- symbol string; return x }

unclozeableParsers = map myreserved unclozeables
puncParsers = map mysymbol [".","?",",",":","-"]

whiteSpace= Token.whiteSpace lexer
lexeme    = Token.lexeme lexer
semi      = Token.semi lexer
symbol      = Token.symbol lexer
natural      = Token.natural lexer
identifier= Token.identifier lexer
reserved  = Token.reserved lexer

runLex :: Show a => Parser a -> String -> IO ()
runLex p input
        = parseTest (do{ whiteSpace
                 ; x <- p
                 ; eof
                 ; return x
                 }) input

time   :: Parser String   -- price in cents
time   = lexeme (do{ minute <- many1 digit
                    ; colon <- symbol ":"
                    ; second <- count 2 digit
                    ; return ( minute ++ colon ++ second )
                    })
          <?> "price"

cloze :: Parser [String]
cloze = do{ ws <- many word
	    ; return ws
            }
	<?> "cloze"

word :: Parser String
word = choice unclozeableParsers
		<|> try time
		<|> punctuation
		<|> do { x <- identifier
			; return (ctest x)
			}
		<|> do { x <- natural; return (ctest (show x)) }
      <?> "word"
      where 
	ctest x = take ((length x)`div`2) x ++ "_" ++ drop ((length x)`div`2) x

punctuation :: Parser String
punctuation = choice puncParsers
