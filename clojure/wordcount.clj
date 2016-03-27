(require '[clojure.string :as str])

(defn -main []
  (let [in (slurp *in*)]
    (->> (-> (str/split in #"\s+")
             frequencies
             (dissoc ""))
         (sort-by (fn [[token freq]] [(- freq) token]))
         (map (fn [[token freq]] (str token "\t" freq)))
         (str/join "\n")
         println)))

(-main)
