import qualified Data.Text as T;
import qualified Data.Text.IO as TextIO;
import qualified Data.List as L;
import qualified Data.HashMap.Strict as H;
import Data.Monoid;

main = TextIO.interact (T.concat . map formatOutput . countWords) where
    formatOutput (word, count) = T.concat [word, T.singleton '\t', T.pack . show $ count, T.singleton '\n']

countWords :: T.Text -> [(T.Text, Int)]
countWords = L.sortBy (\(a, b) (c, d) -> compare d b <> compare a c) .
             H.toList .
             H.fromListWith (+) .
             map (\word -> (word, 1)) .
             filter (/=T.empty) .
             T.split (`elem` "\n\r\t\f ")
