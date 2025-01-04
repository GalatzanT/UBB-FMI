package galasefu.lab6incercare1.service;

import galasefu.lab6incercare1.domain.CererePrietenie;
import galasefu.lab6incercare1.domain.Prietenie;
import galasefu.lab6incercare1.domain.Utilizator;
import galasefu.lab6incercare1.repository.Repository;
import galasefu.lab6incercare1.utils.events.UtilizatorEvent;
import galasefu.lab6incercare1.utils.observer.Observable;
import galasefu.lab6incercare1.utils.observer.Observer;
import jdk.jshell.execution.Util;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


public class UserFriendsService implements Observable<UtilizatorEvent> {


    private Repository<Long, Utilizator> repoUseri;
    private Repository<Long, Prietenie> repoPrietenii;
    private Repository<Long, CererePrietenie> repoCereri;
    private List<Observer<UtilizatorEvent>> observers;

    public UserFriendsService(Repository<Long, Utilizator> repoUseri, Repository<Long, Prietenie> repoPrietenii, Repository<Long, CererePrietenie> repoCereri) {
        this.repoUseri = repoUseri;
        this.repoPrietenii = repoPrietenii;
        this.repoCereri = repoCereri;
        observers = new ArrayList<>();
    }

    //pentru lista de prieteni din homepage
    public Iterable<Utilizator> prieteni_user(Utilizator u) {
        Set<Utilizator> prieteni = new HashSet<>();
        for (Prietenie p : repoPrietenii.findAll())
            if (p.getIdUser1().equals(u.getId()) || p.getIdUser2().equals(u.getId())) {
                if (p.getIdUser1().equals(u.getId())) {
                    repoUseri.findOne(p.getIdUser2()).ifPresent(prieteni::add);
                } else {
                    repoUseri.findOne(p.getIdUser1()).ifPresent(prieteni::add);
                }
            }
        return prieteni;
    }

    //petru login
    public Utilizator findByName(String name) {
        for (Utilizator u : repoUseri.findAll()) {
            if (name.equals(u.getNume())) {
                return u;
            }
        }
        return null;
    }
    // pentru stergerea unui prieten din buton
    public void sterge_prietenie(Utilizator u1, Utilizator u2) {
        for (Prietenie p : repoPrietenii.findAll()) {
            if ((p.getIdUser1().equals(u1.getId()) && p.getIdUser2().equals(u2.getId())) ||
                    (p.getIdUser1().equals(u2.getId()) && p.getIdUser2().equals(u1.getId())))
            {
                repoPrietenii.delete(p.getId());
                // anuntam observarii
            notifyObeservers(new UtilizatorEvent("Prietenie stearsa!"));

            }
        }
        return;
    }

    //functie care returneaza toti useri inafara de owner
    public Iterable<Utilizator> toti_userii(Utilizator u1){
        Set<Utilizator> utilizatori = new HashSet<>();
        for(Utilizator u : repoUseri.findAll()){
            if(!u.equals(u1))
                utilizatori.add(u);
        }
        return utilizatori;
    }
    //pentru text field
    public Iterable<Utilizator> cautaUseri(String nume, Utilizator u1) {
        Set<Utilizator> utilizatoriGasiti = new HashSet<>();

        // Fetch all users except the owner
        Iterable<Utilizator> allUsers = toti_userii(u1);

        // Filter users by name
        for (Utilizator user : allUsers) {
            if (user.getNume().toLowerCase().contains(nume.toLowerCase())) {
                utilizatoriGasiti.add(user);
            }
        }

        return utilizatoriGasiti;
    }

    //trimite_cerere
    public void trimiteCerere(Utilizator owner, Utilizator u){
        CererePrietenie cerere = new CererePrietenie(owner.getId(),u.getId(), LocalDateTime.now(),"de la " + owner.getNume());
        repoCereri.save(cerere);
        notifyObeservers(new UtilizatorEvent("cerere trimisa"));
    }

    //functie care returneaza cererile e prietenie unui user
    public Iterable<CererePrietenie> get_cereri_inbox(Utilizator u){
        Set<CererePrietenie> cereriInbox = new HashSet<>();
        Iterable<CererePrietenie> cereriTotal = repoCereri.findAll();
        for(CererePrietenie cp : cereriTotal)
            if(cp.getId_user2().equals(u.getId()))
                cereriInbox.add(cp);

        return cereriInbox;
    }

    //sterge o cerere
    public void sterge_cerere(CererePrietenie cp){
        repoCereri.delete(cp.getId());
        notifyObeservers(new UtilizatorEvent("Cerere stearsa"));
    }


    public void creare_pritetenie_din_cerere(CererePrietenie cp){
        repoCereri.delete(cp.getId());
        Prietenie p = new Prietenie(cp.getId_user1(), cp.getId_user2(), LocalDateTime.now());
        repoPrietenii.save(p);
        notifyObeservers(new UtilizatorEvent("Cerere acceptata Prieten nou"));
    }


    @Override
    public void addObserver(Observer<UtilizatorEvent> e) {
        observers.add(e);
    }

    @Override
    public void deleteObserver(Observer<UtilizatorEvent> e) {
        observers.remove(e);
    }

    @Override
    public void notifyObeservers(UtilizatorEvent t) {
        observers.forEach(observers -> observers.update(t));
    }
}
