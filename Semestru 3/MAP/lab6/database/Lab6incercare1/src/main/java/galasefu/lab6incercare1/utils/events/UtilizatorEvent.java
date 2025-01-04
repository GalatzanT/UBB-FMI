package galasefu.lab6incercare1.utils.events;


public class UtilizatorEvent implements Event {
    private String mesaj;

    public UtilizatorEvent(String mesaj) {
        this.mesaj = mesaj;
    }

    public String getMesaj(){
        return mesaj;
    }
}
