package clever.bank;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import lombok.NoArgsConstructor;

@NoArgsConstructor
public class CheckMaker {
    public String createFilename() {
        String filePath = "d:\\Clever-Bank\\check\\";
        Date date = Calendar.getInstance().getTime();
        DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh-mm");
        String strDate = dateFormat.format(date);

        Double randNum = Math.random() * 900 + 100; // generate rand num from 100 to 1000
        String rand = randNum.toString();
        String filename = filePath + " " + "check" + strDate + rand + ".txt";
        return filename;

    }

    public void printCheck(int checkNum, String type, String bank, String acId, Double amount)
            throws FileNotFoundException, UnsupportedEncodingException {

        String curCheck = createFilename();
        File check = new File(curCheck);
        Date checkDate = Calendar.getInstance().getTime();
        DateFormat date = new SimpleDateFormat("dd-mm-yyyy");
        DateFormat time = new SimpleDateFormat("hh-mm-ss");
        try (FileWriter fw = new FileWriter(check);
                BufferedWriter bf = new BufferedWriter(fw);
                PrintWriter out = new PrintWriter(bf)) {
            out.print("----------------------------------------\n");
            out.print("|            Банковский чек           |\n");
            out.print("| " + "Чек:" + String.format("%-26s", " ") + checkNum + " |\n");
            out.print("| " + date.format(checkDate) + "                 " + time.format(checkDate) + " |\n");
            out.print("| Тип транзакции:          " + type + " |\n");
            out.print("| Банк отправителя:       " + bank + " |\n");
            out.print("| Банк получателя:        " + bank + " |\n");
            out.print("| Счет отправителя:        " + acId + " |\n");
            out.print("| Счет получателя:         " + acId + " |\n");
            out.print("| Сумма:                   " + amount + " |\n");
            out.print("|-------------------------------------|\n");
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}
