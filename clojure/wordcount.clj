(require '[clojure.string :as str])

(defn -main []
  (let [in (slurp *in*)]
    (->> (str/split in #"\s+")
         (remove str/blank?)
         (group-by identity)
         (map #(list (first %) (-> % second count)))
         (sort-by #(vector (-> % second -) (first %)))
         (map #(str (first %) "\t" (second %)))
         (str/join "\n")
         println)))

(-main)
