package lab5.domain;

public class Entity<ID>  {

    private ID id;
    public ID getId() {
        return id;
    }
    public void setId(ID id) {
        this.id = id;
    }

}