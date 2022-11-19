package MM1;

//Classes de stats: Stockage des données de la simulation
//Affichage des résultats
public class Stats {

    private double _lambda; //Taux d'arrivée
    private double _mu; //Taux de service
    private int _time; //Temps de simulation
    private boolean _is_debug = false; //Mode debug
    private int _nb_clients; //Nombre de clients
    private int _nb_clients_sans_attente; //Nombre de clients sans attente
    private double _temps_attente_cumulle = 0.0; //Temps d'attente cumulé
    private double _nb_clients_cumulle = 0.0; //Nombre de clients cumulé
    private int _nbClientInstantT; //Nombre de clients à l'instant T


    /*
     * Constructeur de la classe Stats
     */
    public Stats(double lambda, double mu, int time, boolean is_debug) {
        _lambda = lambda;
        _mu = mu;
        _time = time;
        _is_debug = is_debug;
    }



    /*
     * Afficher un événement
     */
    public void print_event(Evt evt) {
        if(this._is_debug){
            System.out.print(
                "Date=" + evt.get_date() + 
                "\t" + (evt.get_type()==Evttype.ARRIVE ? "Arrivee" : "Depart") +
                "\t client #" + evt.get_id_client()
            );

            //Si c'est une événemnt de type départ, on affiche la date d'arrivée du client
            if(evt.get_type()==Evttype.DEPART){
                System.out.print(
                    "\t" + "arrivee a t=" + evt.get_arrivee().get_date()
                );
            }
            System.out.println();
        }
    }

    /*
     * Afficher les résultats
     */
    public void print_results() {
        System.out.println();
        print_theorique();
        System.out.println();
        print_pratique();
    }

    /*
     * Afficher les résultats théoriques
     */
    private void print_theorique() {
        System.out.println("--------------------");
        System.out.println("RESULTATS THEORIQUES");
        System.out.println("--------------------");
        System.out.println("Lambda < mu : " + (_lambda < _mu ? "file stable" : "file instable"));
        System.out.println("ro (lambda/mu) = " + (_lambda/_mu));
        System.out.println("nombre de clients attendus (lambda x duree) = " + (_lambda*_time));
        System.out.println("Prob de service sans attente (1 - ro) = " + (1 - (_lambda/_mu)));
        System.out.println("Prob file occupee (ro) = " + (_lambda/_mu));
        System.out.println("Debit (lambda) = " + _lambda);
        System.out.println("Esp nb clients (ro/1-ro) = " + (_lambda/_mu)/(1 - (_lambda/_mu)));
        System.out.println("Temps moyen de sejour (1/mu(1-ro)) = " + (1/(_mu*(1 - (_lambda/_mu)))));
    }

    /*
     * Afficher les résultats pratiques
     */
    private void print_pratique(){
        System.out.println("--------------------");
        System.out.println("RESULTATS SIMULATION");
        System.out.println("--------------------");
        System.out.println("Nombre total de clients = " + _nb_clients); //DEBUG
        System.out.println("Proportion clients sans attente = " + ((double)_nb_clients_sans_attente/(double)_nb_clients)); //DEBUG
        System.out.println("Proportion clients avec attente = " + ((double)(_nb_clients-_nb_clients_sans_attente)/(double)_nb_clients));
        System.out.println("Debit = " + _nb_clients/(double)_time);
        System.out.println("Nb moyen de clients dans systeme = " + ((double)_nb_clients_cumulle/(double)_time));
        System.out.println("Temps moyen de sejour = " + ((double)_temps_attente_cumulle/(double)_nb_clients));

    }
    

    //Getters et setters

    /*
     * Setter du nombre de clients
     */
    public void set_nb_clients(int nb_clients) {
        _nb_clients = nb_clients;
    }

    /*
     * Incrémente le nombre de client sans attente
     */
    public void inc_nb_clients_sans_attente() {
        _nb_clients_sans_attente++;
    }

    /*
     * Incrémente le nombre de client cumulé
     */
    public void inc_nb_clients_cumule(double temps_attente) {
        _nb_clients_cumulle+= _nbClientInstantT * temps_attente;
    }

    /*
     * Incrémente le temps d'attente cumulé
     */
    public void inc_temps_attente_cumulle(double temps_attente) {
        _temps_attente_cumulle += temps_attente;
    }

    /*
     * Getter du nombre de clients à l'instant T
     */
    public int get_nbClientInstantT() {
        return _nbClientInstantT;
    }

    /*
     * Setter du nombre de clients à l'instant T
     */
    public void set_nbClientInstantT(int nbClientInstantT) {
        _nbClientInstantT = nbClientInstantT;
    }


}