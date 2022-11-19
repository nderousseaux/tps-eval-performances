import MM1.Ech;
import MM1.Stats;
public class MM1 {

    private static double _lambda; //Taux d'arrivée
    private static double _mu; //Taux de service
    private static int _time; //Temps de simulation
    private static boolean _is_debug = false; //Mode debug
    
    /**
     * Programme principal. Prend en paramètre lambda, mu, temps et un booleen is_debug.
     * 
     * Commence par initialiser les arguements de la ligne de commande.
     * Ensuite il initialise un échéancier
     */
    public static void main(String[] args){
        //On parse les arguements
        init_arguments(args);

        //On initialise la classe Stats
        Stats s = new Stats(_lambda, _mu, _time, _is_debug);

        //On initialise l'échéancier
        Ech echeancier = new Ech(_lambda, _mu, _time, s); 
        echeancier.start_simulation();

        //On affiche les résultats
        s.print_results();

    }

    /**
     * Initialise et vérifie les arguments de la ligne de commande
     */
    private static void init_arguments(String[] args) {
        //On vérifie que le nombre d'arguments est cohérent
        if (args.length < 3 || args.length > 4){
            print_usage();
            System.exit(1);
       }

       //On vérifie que les arguments ne sont pas nul ou négatifs
       for(int i = 0; i<3; i++){
            boolean error = false;
            switch (i) {
                case 0:
                    double lambda = Double.parseDouble(args[i]);
                    if(lambda <= 0){
                        error = true;
                        break;
                    }
                    _lambda = lambda;
                    break;
                case 1:
                    double mu = Double.parseDouble(args[i]);
                    if(mu <= 0){
                        error = true;
                        break;
                    }
                    _mu = mu;
                    break;
                case 2:
                    int time = Integer.parseInt(args[i]);
                    if(time <= 0){
                        error = true;
                        break;
                    }
                    _time = time;
                default:
                    break;
            }
            if(error){
                System.err.println(String.format("Erreur: %s ne peut pas être inférieur ou égal à 0", args[i]));
                print_usage();
                System.exit(1);
            }
        }

        //On set le debug
        if (args.length == 4){
            int is_debug = Integer.parseInt(args[3]);
            if (is_debug != 0 && is_debug != 1){
                System.err.println("Erreur: debug doit valoir 0 ou 1");
                print_usage();
                System.exit(1);
            }
            _is_debug = is_debug == 1 ? true : false;
        }
    }

    /**
     * Affiche le message d'usage
     */
    private static void print_usage() {
        System.out.println("Usage: MM1 lambda mu duree [debug]");
        System.out.println("  lambda\tParamètre lambda de la fonction exponentielle");
        System.out.println("  mu\t\tParamètre mu de la fonction exponentielle");
        System.out.println("  duree\t\tDurée de la simulation");
        System.out.println("  debug\t\t0: Débogage désactivé (défaut), 1: Débogage activé");
    }
}