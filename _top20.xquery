<html>
<!-- Konstantinos Merkouriadis -->
    <head>
        <link rel="stylesheet" href="style.css"/>
    </head>
    <body>
    <table>
    <tr>
        <th><i>Target</i></th>
        <th><i>Successor</i></th>
        <th><i>Probability</i></th>
    </tr>
{   (:Create a 'has' tuple and its successor (choose from file all 'has'-succ pairs):)
    let $has_success_tuple := for $s in collection('xml-files?select=*.xml')//s
        return   
            for $w in $s/w
            return
                if(lower-case(normalize-space($w/text())) eq 'has') 
                    then
                        let $success := (data($s/w[.>> $w][1]))
                        return
                             (:use ',' as separator of 'has'-succ tuple:)
                             <tuple> {lower-case(normalize-space($w/text()))} {','}{lower-case(normalize-space($success))}</tuple>
                    else  ()
    (:select all words:)
    let $all_words := for $s in collection('xml-files?select=*.xml')//s
        return 
            for $w in $s/w
            return <word>{lower-case(normalize-space($w/text()))}</word>
    (:calculate probability:)       
    let $calculate_probability := for $distinct in distinct-values($has_success_tuple/text())
        let $d := (($has_success_tuple[text() = $distinct])[1])
        (:tokenize the tuple into $arr[1] - 'has' and $arr[2] - 'successor':)
        let $arr := tokenize($d, ',')
        (:count occurrences:)
        let $count := count($has_success_tuple[text() = $distinct])
        (:find total count of successors throughout the text:)
        let $total_count := count($all_words[text()=$arr[2]])
        (:Get and round probability to 2 decimal points,
          if in the middle - round to the closest even number:)
        let $probability := round-half-to-even($count div $total_count, 2)
        (:put in descending order by probability, in ascending by success name:)
        order by $probability descending, $arr[2] ascending
        return
            <tr>
                <td>{$arr[1]}</td>
                <td>{$arr[2]}</td>
                <td>{$probability}</td>
            </tr>
    (:iterate from 1 to 20 - take subsequence of length 20, starting from 1 to take first 20 rows:)        
    return
        for $x in subsequence($calculate_probability, 1, 20)
            return $x
}
    </table>
    </body>
</html>
