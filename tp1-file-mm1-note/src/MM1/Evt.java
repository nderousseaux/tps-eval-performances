package MM1;
//Evt : classe des événements. Elle contient un type (arrivée ou départ) et une date.
//Elle s'occupe aussi d'incrémenter le compteur de clients
public class Evt {
    
    private static int _nb_clients = 0; //Nombre de clients traités

    private Evttype _type_event; //Type de l'évènement 
    private Double _date; //Date de l'évènement
    private int _id_client; //Identifiant du client
    private Evt _arrivee; //Evénement d'arrivée du client

    /*
     * Constructeur de l'évènement
     */
    public Evt(Evttype type_event, Double date) {
        this._type_event = type_event;
        this._date = date;
        this._id_client = _nb_clients;
        _nb_clients++; //On incrémente le compteur de clients
    }

    /*
     * Renvoie l'événement "départ" associé à l'événement
     */
    public Evt get_depart_event(double date) {
        Evt depart = new Evt(Evttype.DEPART, date);
        depart.set_id_client(this._id_client);
        depart.set_arrivee(this);
        _nb_clients--; //On décrémente le compteur de clients car il a été incrémenté dans le constructeur (à tort)
        return depart;
    }

    //Getters et setters

    /*
     * Retourne le nombre de clients traités
     */
    public static int get_nb_clients() {
        return _nb_clients;
    }

    /*
     * Retourne le type de l'évènement
     */
    public Evttype get_type() {
        return this._type_event;
    }

    /*
     * Retourne l'id du client
     */
    public int get_id_client() {
        return this._id_client;
    }

    /*
     * Set l'id du client
     */
    public void set_id_client(int id_client) {
        this._id_client = id_client;
    }

    /*
     * Retourne la date de l'évènement
     */
    public Double get_date() {
        return this._date;
    }

    /*
     * Get l'événement d'arrivée
     */
    public Evt get_arrivee() {
        return this._arrivee;
    }

    /*
     * Set l'événement d'arrivée
     */
    public void set_arrivee(Evt arrivee) {
        this._arrivee = arrivee;
    }

}