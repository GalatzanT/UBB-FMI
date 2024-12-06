package lab5;

import lab5.UI.UIConsole;
import lab5.domain.Utilizator;
import lab5.domain.validators.UtilizatorValidator;
import lab5.repository.Repository;
import lab5.repository.database.UtilizatorDbRepository;
import lab5.service.Service;

// Press Shift twice to open the Search Everywhere dialog and type `show whitespaces`,
// then press Enter. You can now see whitespace characters in your code.
public class Main {
    public static void main(String[] args) {

//        String username="postgres";
//        String pasword="postgres";
//        String url="jdbc:postgresql://localhost:6969/MetGala";
////
//        Repository<Long,Utilizator> userFileRepository3 =
//                new UtilizatorDbRepository(url,username, pasword,  new UtilizatorValidator());
////
//       Utilizator user = new Utilizator("Anghel", "Ciolacu");
//       user.setId(69L);
//       userFileRepository3.save(user);
//       userFileRepository3.findAll().forEach(x-> System.out.println(x));
//        Iterable<Utilizator> users = userFileRepository3.findAll();


        Service service = Service.getInstance();
        UIConsole ui = new UIConsole(service);
        ui.UIrun();

        /*
        Repository<Long, Utilizator> repo = new InMemoryRepository<Long, Utilizator>(new UtilizatorValidator());
        Repository<Long, Utilizator> repoFile = new UtilizatorRepository(new UtilizatorValidator(), "src/data/utlizatori.txt");
        Utilizator u1 = new Utilizator("IONUT", "a");
        Utilizator u2 = new Utilizator("Mihai", "b");
        Utilizator u3 = new Utilizator("ANA", "c");
        Utilizator u4 = null;

        u1.setId(1L);
        u2.setId(2L);
        u3.setId(3L);
        try {
            repoFile.save(u1);
            repoFile.save(u2);
            repoFile.save(u3);
            repoFile.save(u4);
        }catch(IllegalArgumentException e)
        {
            System.out.println(e.getMessage());
        }catch(ValidationException e)
        {
            System.out.println(e.getMessage());
        }
        System.out.println();
      */
    }
}