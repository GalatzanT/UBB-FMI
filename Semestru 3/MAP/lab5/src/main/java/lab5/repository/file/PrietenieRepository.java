package lab5.repository.file;

import lab5.domain.Prietenie;
import lab5.domain.validators.Validator;

public class PrietenieRepository extends AbstractFileRepository<Long, Prietenie> {

    public PrietenieRepository(Validator<Prietenie> validator, String fileName) {
        super(validator, fileName);
    }

    @Override
    public Prietenie createEntity(String line) {
        String[] splited = line.split(";");
        Prietenie p = new Prietenie(Long.parseLong(splited[1]), Long.parseLong(splited[2]));
        p.setId(Long.parseLong(splited[0]));
        return p;
    }

    @Override
    public String saveEntity(Prietenie entity) {
        return entity.getId() + ";" + entity.getIdU1() + ";" + entity.getIdU2();
    }
}