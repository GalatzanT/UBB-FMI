package galasefu.lab6incercare1.controller;

import galasefu.lab6incercare1.domain.CererePrietenie;
import galasefu.lab6incercare1.domain.Utilizator;
import galasefu.lab6incercare1.service.UserFriendsService;
import galasefu.lab6incercare1.utils.events.UtilizatorEvent;
import galasefu.lab6incercare1.utils.observer.Observable;
import galasefu.lab6incercare1.utils.observer.Observer;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;

public class HomepageController implements Observer<UtilizatorEvent> {

    private UserFriendsService userFriendsService;
    private Utilizator owner;

    @FXML
    private Label admin2;

    @FXML
    private ListView<Utilizator> friendsListView;

    private ObservableList<Utilizator> friendsList = FXCollections.observableArrayList();


   //lista pentru useri
    private ObservableList<Utilizator> useriList = FXCollections.observableArrayList();

    @FXML
    private ListView<Utilizator> useriListView;

    //buton cautare useri
    @FXML
    private TextField textCautare;


    //lista de cereri

    private ObservableList<CererePrietenie> cereriList = FXCollections.observableArrayList();

    @FXML
    private ListView<CererePrietenie> cereriListView;






    //settings :) pentru home page
    public void setOwner(Utilizator u) {
        owner = u;
        admin2.setText("Bine ai revenit " + owner.getNume());
        populateFriendsList();
        populam_lista_useri();
        populam_lista_cereri();
    }

    public void setUserFriendsService(UserFriendsService service) {
        this.userFriendsService = service;

        this.userFriendsService.addObserver(this);
    }
    //populam lista de prieteni
    private void populateFriendsList() {
        friendsList.clear();
        Iterable<Utilizator> friends = userFriendsService.prieteni_user(owner);
        friends.forEach(friendsList::add);
        friendsListView.setItems(friendsList);
    }

    //populam si useri
    private void populam_lista_useri(){
        useriList.clear();
        Iterable<Utilizator> useri = userFriendsService.toti_userii(owner);
        useri.forEach(useriList::add);
        useriListView.setItems(useriList);
    }



    //sterge un prieten buton
    @FXML
    private void handleDeleteFriend() {
        Utilizator selectedFriend = friendsListView.getSelectionModel().getSelectedItem();
        if (selectedFriend != null) {
            System.out.println("Deleting friend: " + selectedFriend.getNume());
            userFriendsService.sterge_prietenie(owner,selectedFriend);
        } else {
            System.out.println("No friend selected for deletion!");
        }
    }

    @FXML
    public void text_cautare_dinamica() {
        textCautare.textProperty().addListener((observable, oldValue, newValue) -> {
            useriList.clear();
            if (!newValue.isEmpty()) {
                Iterable<Utilizator> filteredUsers = userFriendsService.cautaUseri(newValue,owner);
                filteredUsers.forEach(useriList::add);
            } else {
                Iterable<Utilizator> allUsers = userFriendsService.toti_userii(owner);
                allUsers.forEach(useriList::add);
            }
            useriListView.setItems(useriList);
        });
    }



    ///CERERI DE PRIETENIE


    @FXML
    public void buton_trimite_cerere(){
        Utilizator user = useriListView.getSelectionModel().getSelectedItem();
        if(user != null){
            System.out.println("Se trimite cerere lui " + user.getNume());
            userFriendsService.trimiteCerere(owner,user);
        } else {
            System.out.println("Nu e selectat nici un user");
        }
    }

    //refresh automat lista de cereri
    public void populam_lista_cereri(){
        cereriList.clear();
        Iterable<CererePrietenie> cereri = userFriendsService.get_cereri_inbox(owner);
        cereri.forEach(cereriList :: add);
        cereriListView.setItems(cereriList);
    }

    @FXML
    public void refuz_cerere(){
        CererePrietenie cerere = cereriListView.getSelectionModel().getSelectedItem();
        if(cerere!=null){
            userFriendsService.sterge_cerere(cerere);
            System.out.println("Cererea s-a sters");
        }else{
            System.out.println("Nu ai selectat nici o cerere");
        }

    }

    @FXML
    public  void accept_cerere(){
        CererePrietenie cp = cereriListView.getSelectionModel().getSelectedItem();
        if(cp!=null){
            userFriendsService.creare_pritetenie_din_cerere(cp);
            System.out.println("S-a acceptat cererea de prietenie");
        }else{
            System.out.println("Nu ai selectat nici o cerere");
        }
    }

    //cand trimite service-ul un update o sa se apeleze toti observeri de homepage
    @Override
    public void update(UtilizatorEvent utilizatorEvent) {
        //dam refresh la lista de prieteni
        populateFriendsList();
        //dam refresh la cereri
        populam_lista_cereri();
    }
}
