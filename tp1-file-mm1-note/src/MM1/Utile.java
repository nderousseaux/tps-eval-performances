package MM1;

public class Utile{

    /*
     * Calcule la prochaine date d'arrivée ou la durée de service
     * Param = lambda pour la prochaine date d'arrivée et mu pour la durée de service
     */
    public static double expo(double param, double time){

        //Ti+1 = Ti + -log(1-x)/lambda avec x un nombre aléatoire entre 0 et 1 (variable uniforme)
        // double va = _random.nextDouble();

        // return time + ( ( -Math.log(1 - va) ) / param );
        return (
            time + 
            (
                (-Math.log(1-Math.random()))/
                param
            )
        );
    }

}