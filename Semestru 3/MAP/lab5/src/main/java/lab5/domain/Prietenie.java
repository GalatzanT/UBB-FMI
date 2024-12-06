package lab5.domain;

import java.util.Objects;

public class Prietenie extends Entity<Long> {
    Long idU1;
    Long idU2;

    public Prietenie(Long idU1, Long idU2) {
        System.out.println("[Constructor Prietenie]");
        this.idU1 = idU1;
        this.idU2 = idU2;
    }

    public Long getIdU1() {
        return idU1;
    }

    public void setIdU1(Long idU1) {
        this.idU1 = idU1;
    }

    public Long getIdU2() {
        return idU2;
    }

    public void setIdU2(Long idU2) {
        this.idU2 = idU2;
    }

    @Override
    public String toString() {
        return "Prietenie{" +
                "idU1=" + idU1 +
                ", idU2=" + idU2 +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Prietenie prietenie = (Prietenie) o;
        return Objects.equals(idU1, prietenie.idU1) && Objects.equals(idU2, prietenie.idU2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idU1, idU2);
    }
}
