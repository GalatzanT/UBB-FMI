package lab5.UI;

import lab5.domain.Prietenie;
import lab5.domain.Utilizator;
import lab5.domain.validators.ValidationException;
import lab5.repository.RepoException;
import lab5.service.Service;
import lab5.service.ServiceException;

import java.util.List;
import java.util.Map;
import java.util.Scanner;


public class UIConsole extends AbstractUIConsole {

    private final Scanner cin;

    public UIConsole(Service serviceconsole) {
        super(serviceconsole);
        this.cin = new Scanner(System.in);
    }

    public void UIrun() {
        System.out.println("Welcome to MetGala");

        Map<String, Runnable> comenzi = Map.ofEntries(
                Map.entry("users", this::showUsers),
                Map.entry("adauga_user", this::addUser),
                Map.entry("sterge_user", this::deleteUser),
                Map.entry("update_user", this::updateUser),
                Map.entry("prietenii", this::showPrietenii),
                Map.entry("adauga_prietenie", this::addPritenie),
                Map.entry("sterge_prietenie", this::deletePrietenie),
                Map.entry("nr_comunitati", this::numarulDeComunitati),
                Map.entry("comunitate_sociabila", this::ceaMaiSociabilaComunitate)
        );

        while (true) {
            System.out.println("Optiuni: users, adauga_user, sterge_user, update_user, prietenii, adauga_prietenie, sterge_prietenie, nr_comunitati, comunitate_sociabila ");
            System.out.print(">>>");

            String raspuns = cin.nextLine();
            try {
                if (comenzi.containsKey(raspuns)) {
                    comenzi.get(raspuns).run();
                } else {
                    System.out.println("Nu exista aceasta optiune");
                }
            } catch (ValidationException | RepoException | ServiceException e) {
                System.out.println(e.getMessage());
                System.out.println("Mergem inapoi la  meniul principal");
            }
        }
    }


    public void showUsers() {
        System.out.println("Utilizatorii nostri:");
        Iterable<Utilizator> utilizatori = serviceconsole.getAllUtilizatori();
        utilizatori.forEach(utilizator -> System.out.println(utilizator.toString()));
    }


    public void addUser() {
        System.out.print("Introdu numele de familie al utilizatorului:");
        String FName = cin.nextLine();
        System.out.print("Introdu prenumele utilizatorului:");
        String LName = cin.nextLine();
        serviceconsole.addUtilizator(FName, LName);

        System.out.println("Bine ai venit in MetGala " + FName + " " + LName);
    }

    public void deleteUser() {
        Long idSters = null;
        boolean validInput = false;

        while (!validInput) {
            try {
                System.out.print("Introdu te rog ID-ul userului pe care dorești să îl ștergi: ");
                idSters = Long.parseLong(cin.nextLine());
                validInput = true;
            } catch (NumberFormatException e) {
                System.out.println("Eroare: ID-ul trebuie să fie un număr întreg. Încearcă din nou.");
            }
        }

        try {
            serviceconsole.deleteUtilizator(idSters);
            System.out.println("Utilizatorul cu ID-ul " + idSters + " a fost șters cu succes.");
        } catch (Exception e) {
            System.out.println("Eroare la ștergerea utilizatorului: " + e.getMessage());
        }
    }


    public void showPrietenii() {
        System.out.println("Prieteniile sunt intre useri cu acaeste id-uri");
        Iterable<Prietenie> prietenii = serviceconsole.getAllPrietenii();
        prietenii.forEach(prietenie -> System.out.println(prietenie.toString()));
    }

    public void addPritenie() {
        Long id1 = null;
        Long id2 = null;
        boolean loop = false;
        System.out.println("Alege 2 id-uri pentru a lega o prietenie intre 2 useri");
        while (!loop) {
            try {
                System.out.print("id1: ");
                id1 = Long.parseLong(cin.nextLine());
                loop = true;
            } catch (NumberFormatException e) {
                System.out.println("Eroare: ID-ul trebuie să fie un număr întreg. Încearcă din nou.");
            }
        }
        loop = false;
        while (!loop) {
            try {
                System.out.print("id2: ");
                id2 = Long.parseLong(cin.nextLine());
                loop = true;
            } catch (NumberFormatException e) {
                System.out.println("Eroare: ID-ul trebuie să fie un număr întreg. Încearcă din nou.");
            }
        }
        try {
            serviceconsole.addPrietenie(id1, id2);
            System.out.println("Prietenie adaugata cu succes");
        } catch (Exception e) {
            System.out.println(e.getMessage() + " eroare la adaugarea priteniei");
        }

    }

    public void deletePrietenie() {
        Long idSters = null;
        boolean validInput = false;

        while (!validInput) {
            try {
                System.out.print("Introdu te rog ID-ul prieteniei să îl ștergi: ");
                idSters = Long.parseLong(cin.nextLine());
                validInput = true;
            } catch (NumberFormatException e) {
                System.out.println("Eroare: ID-ul trebuie să fie un număr întreg. Încearcă din nou.");
            }
        }
        try {
            serviceconsole.deletePrietenie(idSters);
            System.out.println("Prietenie stearsa cu succes");
        } catch (Exception e) {
            System.out.println(e.getMessage() + " eroare la stergerea priteniei");
        }
    }

    public void numarulDeComunitati() {
        int nrComunitati = serviceconsole.getNumberOfCommunities();
        System.out.println("Numarul de comunitati este: " + nrComunitati);
    }

    public void ceaMaiSociabilaComunitate() {
        List<Long> mostSociableCommunity = serviceconsole.getMostSociableCommunity();
        System.out.println("Comunitatea cea mai sociabila are utilizatorii cu ID-urile: " + mostSociableCommunity);

    }

    private void updateUser() {
        try {
            System.out.print("Introdu ID-ul utilizatorului pe care dorești să-l actualizezi: ");
            Long id = Long.parseLong(cin.nextLine());

            System.out.print("Introdu noul nume de familie al utilizatorului: ");
            String firstName = cin.nextLine();

            System.out.print("Introdu noul prenume al utilizatorului: ");
            String lastName = cin.nextLine();

            Utilizator utilizatorActualizat = serviceconsole.updateUtilizator(id, firstName, lastName);
            System.out.println("Utilizator actualizat cu succes: " + utilizatorActualizat);
        } catch (NumberFormatException e) {
            System.out.println("ID-ul introdus nu este valid!");
        } catch (ServiceException e) {
            System.out.println("Eroare la actualizare: " + e.getMessage());
        }
    }




}






