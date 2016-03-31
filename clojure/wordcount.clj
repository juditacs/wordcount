(require '[clojure.string :as str])
(require '[clojure.java.io :as io])

(defn -main []
  (let [lines (-> *in* java.io.BufferedReader. line-seq)
        words (mapcat #(str/split % #"\s+") lines)
        freq (frequencies words)]
    (->> (dissoc freq "")
         (sort-by (fn [[token freq]] [(- freq) token]))
         (map (fn [[token freq]] (println (str token "\t" freq))))
         dorun)))

(-main)
