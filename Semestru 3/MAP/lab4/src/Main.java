import UI.UIConsole;
import domain.Utilizator;
import domain.validators.UtilizatorValidator;
import domain.validators.ValidationException;
import repository.Repository;
import repository.file.UtilizatorRepository;
import repository.memory.InMemoryRepository;
import service.Service;
import service.ServiceException;

// Press Shift twice to open the Search Everywhere dialog and type `show whitespaces`,
// then press Enter. You can now see whitespace characters in your code.
public class Main {
    public static void main(String[] args) {

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