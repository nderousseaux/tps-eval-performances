package MM1;
import java.util.LinkedList;


//Ech : classe de l’échéancier
//Elle gère un par un les événements de la simulation et ajoute les événements suivants
public class Ech {

    private double _lambda; //Taux d'arrivée
    private double _mu; //Taux de service
    private int _time; //Temps de simulation
    private Stats _stats; //Classe de stats
    private LinkedList<Evt> _evenements; //Liste des événements
    private double _last_departure_time = 0; //Dernier date de départ
    private double _last_event_time = 0; //Dernier date d'événement

    /*
     * Constructeur de l'échéancier.
     * Initialise les attributs 
     * Crée un premier événement de type arrivée à T=0
     */
    public Ech(double lambda, double mu, int time, Stats stats) {
        _lambda = lambda;
        _mu = mu;
        _time = time;
        _stats = stats;
        _evenements = new LinkedList<Evt>();

        Evt evt = new Evt(Evttype.ARRIVE, 0.0);
        add_evt(evt);
    }

    /*
     * Démarre la simulation
     */
    public void start_simulation() {
        //La simulation se termine quand l'échéancier est vide
        while(!_evenements.isEmpty()){
            traiter_next_evenement();
        }
        //On donne le nombre de clients à Stats
        _stats.set_nb_clients(Evt.get_nb_clients());
    }

    /*
     * Traiter un événement
     */
    private void traiter_next_evenement() {

        Evt evt = _evenements.pop();

        //Entre deux événements, on enregistre le nombre de client présent dans le système
        _stats.inc_nb_clients_cumule(evt.get_date() - _last_event_time);
        _last_event_time = evt.get_date();

        switch (evt.get_type()) {
            case ARRIVE:
                traiter_arrive(evt);
                break;
            case DEPART:
                traiter_depart(evt);
                break;
            default:
                break;
        }
    }

    /*
     * Traiter un événement de type ARRIVE
     */
    private void traiter_arrive(Evt evt) {

        _stats.set_nbClientInstantT(_stats.get_nbClientInstantT() + 1);

        //On récupère la date de dernière sortie (pour le calcul du temps d'attente de ce client)
        double last_depart = this._last_departure_time;
        //Sauf si l'échéancier est vide, alors le client est servi immédiatement
        if(_evenements.isEmpty()){
            last_depart = evt.get_date();
            _stats.inc_nb_clients_sans_attente();
        }

        //On ajoute le départ du client dans la file
        double date_depart = Utile.expo(_mu, last_depart); //Mu pour la durée de service
        _last_departure_time = date_depart;
        Evt depart = evt.get_depart_event(date_depart);
        add_evt(depart);

        //On ajouter la prochaine arrivée dans la file(si elle ne dépasse pas la fin de la simulation)
        double date_arrive = Utile.expo(_lambda, evt.get_date()); //Lambda pour la prochaine date d'arrivée
        if(date_arrive <= _time){
            Evt arrive = new Evt(Evttype.ARRIVE, date_arrive);
            add_evt(arrive);
        }

        //On affiiche l'arrivée
        _stats.print_event(evt);
    }

    /*
     * Traiter un événement de type DEPART
     */
    private void traiter_depart(Evt evt) {
        //On enregistre le départ du client
        _stats.inc_temps_attente_cumulle(evt.get_date() - evt.get_arrivee().get_date());
        _stats.set_nbClientInstantT(_stats.get_nbClientInstantT() - 1);

        //On affiche le départ
        _stats.print_event(evt);
    }

    /*
     * Ajoute un événement à l'échéancier
     */
    public void add_evt(Evt evt) {
        //On ajoute l'événement au bon endroit dans la liste (trié par date)
        int i = 0;
        for (Evt e : _evenements) {
            if(e.get_date() > evt.get_date()){
                break;
            }
            i++;
        }
        _evenements.add(i, evt);
    }
}