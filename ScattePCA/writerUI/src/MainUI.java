
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.FileDialog;
import java.awt.Frame;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Rectangle;
import java.awt.Robot;

import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.EmptyBorder;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.border.LineBorder;

import java.awt.Color;
import java.awt.ComponentOrientation;

import javax.swing.JLabel;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.swing.UIManager;

import com.mathworks.toolbox.javabuilder.*;
import matlabjet.*;

public class MainUI extends JFrame {

    /**
     *
     */
    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private int count=0;
    MainUI view = this;
    MainUI frm = this;
    int drag_status=0,c1,c2,c3,c4;
    BufferedImage image;
    int a,b,c,d;
    BufferedImage IM;
    private JLabel Label;
    //	改变图片大小
    private ImageIcon scaleImage(int a,int b,ImageIcon icon) {

        Image image = icon.getImage();
        image = image.getScaledInstance(a,b, Image.SCALE_DEFAULT);

        return new ImageIcon(image);
    }
    /**
     * Launch the application.
     */
//	主函数      ：创建一个主窗体
    public static void main(String[] args)  throws  MWException{
        String modelfile="modelfile";
        Object[] person = null;
        MatlabJet matlab_jet=new MatlabJet();
        String path_to_db="F:\\dataset\\3_28\\smalltemp";
        MWNumericArray train_length = new MWNumericArray(Double.valueOf(10),MWClassID.DOUBLE);
        matlab_jet.train_writers(1,path_to_db,train_length,modelfile);
        String testimg="F:\\dataset\\3_28\\smalltemp\\2\\g0201.0.0.jpg";
        person=matlab_jet.test_writer(1,modelfile,train_length,testimg);
        System.out.println(person[0]);
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    MainUI frame = new MainUI();
                    frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Create the frame.
     */


    public MainUI() {
        setResizable(false);
        setTitle("\u5B9E\u9A8C");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(0, 0, 1140, 660);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        contentPane.setLayout(new BorderLayout(0, 0));
        setContentPane(contentPane);

        JPanel panel_1 = new JPanel();
        panel_1.setBorder(new LineBorder(new Color(0, 0, 0)));
        panel_1.setPreferredSize(new Dimension(450,35));
        contentPane.add(panel_1, BorderLayout.NORTH);
        panel_1.setLayout(null);

        Label = new JLabel("");
        Label.setBackground(Color.WHITE);

        JButton btnNewButton = new JButton("\u6253\u5F00\u539F\u59CB\u56FE\u7247");
        btnNewButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent arg0) {
                FileDialog fd = new FileDialog(view, "打开图片", FileDialog.LOAD);
                fd.setVisible(true);
                String f =fd.getDirectory()+fd.getFile();
                ImageIcon icon = new ImageIcon(f,"");
                Label.setIcon(icon);
            }
        });
        btnNewButton.setBounds(340, 5, 120, 23);
        panel_1.add(btnNewButton);

        JButton btnNewButton_1 = new JButton("\u52A0\u8F7D\u6570\u636E\u96C6");
        btnNewButton_1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                FileDialog fd = new FileDialog(new Frame(),"选择数据集");
                fd.setVisible(true);
            }
        });
        btnNewButton_1.setBounds(10, 5, 100, 23);
        panel_1.add(btnNewButton_1);

        JButton btnNewButton_2 = new JButton("\u8BAD\u7EC3");
        btnNewButton_2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent arg0) {
            }
        });
        btnNewButton_2.setBounds(120, 5, 100, 23);
        panel_1.add(btnNewButton_2);

        final JButton btnNewButton_3 = new JButton("\u6D4B\u8BD5\u6837\u672C");
        btnNewButton_3.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                FileDialog fd = new FileDialog(new Frame(), "选择测试样本", FileDialog.LOAD);
                fd.setVisible(true);
                String f =fd.getDirectory()+fd.getFile();
                ImageIcon icon = new ImageIcon(f,"");
                Label.setIcon(icon);
            }
        });
        btnNewButton_3.setBounds(230, 5, 100, 23);
        panel_1.add(btnNewButton_3);

        JPanel panel_2 = new JPanel();
        panel_2.setVerifyInputWhenFocusTarget(false);
        panel_2.setBorder(new LineBorder(new Color(0, 0, 0)));
        panel_2.setPreferredSize(new Dimension(500, 0));
        contentPane.add(panel_2, BorderLayout.WEST);
        panel_2.setLayout(null);

        JLabel label1 = new JLabel("\u9700\u8981\u6D4B\u8BD5\u7684\u56FE\u7247");
        label1.setBounds(203, 5, 100, 15);
        panel_2.add(label1);

        JScrollPane scrollPane=new JScrollPane(Label);
        scrollPane.setBounds(10, 33, 480, 500);
        panel_2.add(scrollPane);

        scrollPane.addMouseListener(new MouseListener(){
            public void mouseClicked(MouseEvent arg0) {
            }
            public void mouseEntered(MouseEvent arg0) {
            }
            public void mouseExited(MouseEvent arg0) {
            }
            public void mousePressed(MouseEvent arg0) {
                c1=arg0.getX();
                c2=arg0.getY();
            }
            public void mouseReleased(MouseEvent arg0) {
                if(drag_status==1)
                {
                    c3=arg0.getX();
                    c4=arg0.getY();
                    try
                    {
                        int w = c1 - c3;
                        int h = c2 - c4;
                        w = w * -1;
                        h = h * -1;
                        Robot robot = new Robot();
                        image = robot.createScreenCapture(new Rectangle(c1+19, c2+99,w,h));
                    }
                    catch(Exception e)
                    {
                        e.printStackTrace();
                    }
                }
            }
        });
        scrollPane.addMouseMotionListener(new MouseMotionListener(){
            public void mouseDragged(MouseEvent arg0){
                repaint();
                drag_status=1;
                c3=arg0.getX();
                c4=arg0.getY();
                Graphics g = getGraphics();
                g.setColor(Color.BLUE);
                g.drawRect(c1+19, c2+99, c3-c1, c4-c2);
            }
            public void mouseMoved(MouseEvent arg0) {
                Graphics g = getGraphics();
                g.setColor(Color.BLUE);
                g.drawRect(c1+19, c2+99, c3-c1, c4-c2);

            }
        });

        JPanel panel_3 = new JPanel();
        panel_3.setToolTipText("");
        contentPane.add(panel_3, BorderLayout.CENTER);
        panel_3.setLayout(null);

        JButton btnNewButton_5 = new JButton("\u53D6\u6D88");
        btnNewButton_5.setBounds(25, 53, 68, 23);
        panel_3.add(btnNewButton_5);

        JPanel panel_4 = new JPanel();
        panel_4.setBorder(new LineBorder(new Color(0, 0, 0)));
        panel_4.setPreferredSize(new Dimension(500, 0));
        contentPane.add(panel_4, BorderLayout.EAST);
        panel_4.setLayout(null);
//		panel_3的鼠标事件监听
        panel_4.addMouseListener(new MouseListener(){
            public void mouseClicked(MouseEvent arg0) {
                // 处理鼠标点击
            }
            public void mouseEntered(MouseEvent arg0) {
                // 处理鼠标移入
            }
            public void mouseExited(MouseEvent arg0) {
                // 处理鼠标离开
            }
            public void mousePressed(MouseEvent arg0) {
//				repaint();
                a=arg0.getX();
                b=arg0.getY();
            }
            public void mouseReleased(MouseEvent arg0) {
                if(drag_status==1)
                {
                    c=arg0.getX();
                    d=arg0.getY();
                    try
                    {
                        int w = a - c;
                        int h = b - d;
                        w = w * -1;
                        h = h * -1;
                        Robot robot = new Robot();
                        IM = robot.createScreenCapture(new Rectangle(a+32+480+120, b+67,w,h));
                    }
                    catch(Exception e)
                    {
                        e.printStackTrace();
                    }
                }
            }
        });
        panel_4.addMouseMotionListener(new MouseMotionListener(){
            public void mouseDragged(MouseEvent arg0){
                repaint();
                drag_status=1;
                c=arg0.getX();
                d=arg0.getY();
                Graphics g = getGraphics();
                g.setColor(Color.BLUE);
                g.drawRect(a+32+480+120, b+67, c-a, d-b);
            }
            public void mouseMoved(MouseEvent arg0) {
                Graphics g = getGraphics();
                g.setColor(Color.BLUE);
                g.drawRect(a+32+480+120, b+67, c-a, d-b);

            }
        });

        JLabel label2 = new JLabel("\u63D0\u53D6\u51FA\u6765\u7684\u6587\u5B57");
        label2.setBounds(201, 5, 100, 15);
        panel_4.add(label2);

        final JLabel label_1 = new JLabel("");
        label_1.setForeground(UIManager.getColor("Button.disabledShadow"));
        label_1.setBounds(10, 30, 60, 60);
        panel_4.add(label_1);

        final JLabel label_2 = new JLabel("");
        label_2.setBounds(70, 30, 60, 60);
        panel_4.add(label_2);

        final JLabel label_3 = new JLabel("");
        label_3.setBounds(130, 30, 60, 60);
        panel_4.add(label_3);

        final JLabel label_4 = new JLabel("");
        label_4.setBounds(190, 30, 60, 60);
        panel_4.add(label_4);

        final JLabel label_5 = new JLabel("");
        label_5.setBounds(250, 30, 60, 60);
        panel_4.add(label_5);

        final JLabel label_6 = new JLabel("");
        label_6.setBounds(310, 30, 60, 60);
        panel_4.add(label_6);

        final JLabel label_7 = new JLabel("");
        label_7.setBounds(370, 30, 60, 60);
        panel_4.add(label_7);

        final JLabel label_8 = new JLabel("");
        label_8.setBounds(430, 30, 60, 60);
        panel_4.add(label_8);

        final JLabel label_9 = new JLabel("");
        label_9.setBounds(10, 90, 60, 60);
        panel_4.add(label_9);

        final JLabel label_10 = new JLabel("");
        label_10.setBounds(70, 90, 60, 60);
        panel_4.add(label_10);

        final JLabel label_11 = new JLabel("");
        label_11.setBounds(130, 90, 60, 60);
        panel_4.add(label_11);

        final JLabel label_12 = new JLabel("");
        label_12.setBounds(190, 90, 60, 60);
        panel_4.add(label_12);

        final JLabel label_13 = new JLabel("");
        label_13.setBounds(250, 90, 60, 60);
        panel_4.add(label_13);

        final JLabel label_14 = new JLabel("");
        label_14.setBounds(310, 90, 60, 60);
        panel_4.add(label_14);

        final JLabel label_15 = new JLabel("");
        label_15.setBounds(370, 90, 60, 60);
        panel_4.add(label_15);

        final JLabel label_16 = new JLabel("");
        label_16.setBounds(430, 90, 60, 60);
        panel_4.add(label_16);

        final JLabel label_17 = new JLabel("");
        label_17.setBounds(10, 150, 60, 60);
        panel_4.add(label_17);

        final JLabel label_18 = new JLabel("");
        label_18.setBounds(70, 150, 60, 60);
        panel_4.add(label_18);

        final JLabel label_19 = new JLabel("");
        label_19.setBounds(130, 150, 60, 60);
        panel_4.add(label_19);

        final JLabel label_20 = new JLabel("");
        label_20.setBounds(190, 150, 60, 60);
        panel_4.add(label_20);

        final JLabel label_21 = new JLabel("");
        label_21.setBounds(250, 150, 60, 60);
        panel_4.add(label_21);

        final JLabel label_22 = new JLabel("");
        label_22.setBounds(310, 150, 60, 60);
        panel_4.add(label_22);

        final JLabel label_23 = new JLabel("");
        label_23.setBounds(370, 150, 60, 60);
        panel_4.add(label_23);

        final JLabel label_24 = new JLabel("");
        label_24.setBounds(430, 150, 60, 60);
        panel_4.add(label_24);

        final JLabel label_25 = new JLabel("");
        label_25.setBounds(10, 210, 60, 60);
        panel_4.add(label_25);

        final JLabel label_26 = new JLabel("");
        label_26.setBounds(70, 210, 60, 60);
        panel_4.add(label_26);

        final JLabel label_27 = new JLabel("");
        label_27.setBounds(130, 210, 60, 60);
        panel_4.add(label_27);

        final JLabel label_28 = new JLabel("");
        label_28.setBounds(190, 210, 60, 60);
        panel_4.add(label_28);

        final JLabel label_29 = new JLabel("");
        label_29.setBounds(250, 210, 60, 60);
        panel_4.add(label_29);

        final JLabel label_30 = new JLabel("");
        label_30.setBounds(310, 210, 60, 60);
        panel_4.add(label_30);

        final JLabel label_31 = new JLabel("");
        label_31.setBounds(370, 210, 60, 60);
        panel_4.add(label_31);

        final JLabel label_32 = new JLabel("");
        label_32.setBounds(430, 210, 60, 60);
        panel_4.add(label_32);

        final JLabel label_33 = new JLabel("");
        label_33.setBounds(10, 270, 60, 60);
        panel_4.add(label_33);

        final JLabel label_34 = new JLabel("");
        label_34.setBounds(70, 270, 60, 60);
        panel_4.add(label_34);

        final JLabel label_35 = new JLabel("");
        label_35.setBounds(130, 270, 60, 60);
        panel_4.add(label_35);

        final JLabel label_36 = new JLabel("");
        label_36.setBounds(190, 270, 60, 60);
        panel_4.add(label_36);

        final JLabel label_37 = new JLabel("");
        label_37.setBounds(250, 270, 60, 60);
        panel_4.add(label_37);

        final JLabel label_38 = new JLabel("");
        label_38.setBounds(310, 270, 60, 60);
        panel_4.add(label_38);

        final JLabel label_39 = new JLabel("");
        label_39.setBounds(370, 270, 60, 60);
        panel_4.add(label_39);

        final JLabel label_40 = new JLabel("");
        label_40.setBounds(430, 270, 60, 60);
        panel_4.add(label_40);

        final JLabel label_41 = new JLabel("");
        label_41.setBounds(10, 330, 60, 60);
        panel_4.add(label_41);

        final JLabel label_42 = new JLabel("");
        label_42.setBounds(70, 330, 60, 60);
        panel_4.add(label_42);

        final JLabel label_43 = new JLabel("");
        label_43.setBounds(130, 330, 60, 60);
        panel_4.add(label_43);

        final JLabel label_44 = new JLabel("");
        label_44.setBounds(190, 330, 60, 60);
        panel_4.add(label_44);

        final JLabel label_45 = new JLabel("");
        label_45.setBounds(250, 330, 60, 60);
        panel_4.add(label_45);

        final JLabel label_46 = new JLabel("");
        label_46.setBounds(310, 330, 60, 60);
        panel_4.add(label_46);

        final JLabel label_47 = new JLabel("");
        label_47.setBounds(370, 330, 60, 60);
        panel_4.add(label_47);

        final JLabel label_48 = new JLabel("");
        label_48.setBounds(430, 330, 60, 60);
        panel_4.add(label_48);

        final JLabel label_49 = new JLabel("");
        label_49.setBounds(10, 390, 60, 60);
        panel_4.add(label_49);

        final JLabel label_50 = new JLabel("");
        label_50.setBounds(70, 390, 60, 60);
        panel_4.add(label_50);

        final JLabel label_51 = new JLabel("");
        label_51.setBounds(130, 390, 60, 60);
        panel_4.add(label_51);

        final JLabel label_52 = new JLabel("");
        label_52.setBounds(190, 390, 60, 60);
        panel_4.add(label_52);

        final JLabel label_53 = new JLabel("");
        label_53.setBounds(250, 390, 60, 60);
        panel_4.add(label_53);

        final JLabel label_54 = new JLabel("");
        label_54.setBounds(310, 390, 60, 60);
        panel_4.add(label_54);

        final JLabel label_55 = new JLabel("");
        label_55.setBounds(370, 390, 60, 60);
        panel_4.add(label_55);

        final JLabel label_56 = new JLabel("");
        label_56.setBounds(430, 390, 60, 60);
        panel_4.add(label_56);

        final JLabel label_57 = new JLabel("");
        label_57.setBounds(10, 450, 60, 60);
        panel_4.add(label_57);

        final JLabel label_58 = new JLabel("");
        label_58.setBounds(70, 450, 60, 60);
        panel_4.add(label_58);

        final JLabel label_59 = new JLabel("");
        label_59.setBounds(130, 450, 60, 60);
        panel_4.add(label_59);

        final JLabel label_60 = new JLabel("");
        label_60.setBounds(190, 450, 60, 60);
        panel_4.add(label_60);

        final JLabel label_61 = new JLabel("");
        label_61.setBounds(250, 450, 60, 60);
        panel_4.add(label_61);

        final JLabel label_62 = new JLabel("");
        label_62.setBounds(310, 450, 60, 60);
        panel_4.add(label_62);

        final JLabel label_63 = new JLabel("");
        label_63.setBounds(370, 450, 60, 60);
        panel_4.add(label_63);

        final JLabel label_64 = new JLabel("");
        label_64.setBounds(430, 450, 60, 60);
        panel_4.add(label_64);

        JButton button = new JButton("\u6D4B\u8BD5");
        button.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String f="临时图片";
                File file = new File(f+""+"."+"jpg");
                try {
                    ImageIO.write(IM, "jpg", file);
                }catch (IOException e1) {
                    e1.printStackTrace();
                }
                ImageIcon icon = new ImageIcon("临时图片.jpg");
                Label.setIcon(scaleImage(480,480,icon));
                file.delete();
            }
        });
        button.setBounds(220, 520, 93, 23);
        panel_4.add(button);

        final JButton btnNewButton_4 = new JButton("\u63D0\u53D6");
//		btnNewButton_4的鼠标点击监听
        btnNewButton_4.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                ImageIcon icon = new ImageIcon(image);
//			    给每个标签加Icon			    
                count++;
                if(count==1){
                    label_1.setIcon(scaleImage(60,60,icon));
                }
                else if(count==2){
                    label_2.setIcon(scaleImage(60,60,icon));
                }
                else if(count==3){
                    label_3.setIcon(scaleImage(60,60,icon));
                }
                else if(count==4){
                    label_4.setIcon(scaleImage(60,60,icon));
                }
                else if(count==5){
                    label_5.setIcon(scaleImage(60,60,icon));
                }
                else if(count==6){
                    label_6.setIcon(scaleImage(60,60,icon));
                }
                else if(count==7){
                    label_7.setIcon(scaleImage(60,60,icon));
                }
                else if(count==8){
                    label_8.setIcon(scaleImage(60,60,icon));
                }
                else if(count==9){
                    label_9.setIcon(scaleImage(60,60,icon));
                }
                else if(count==10){
                    label_10.setIcon(scaleImage(60,60,icon));
                }
                else if(count==11){
                    label_11.setIcon(scaleImage(60,60,icon));
                }
                else if(count==12){
                    label_12.setIcon(scaleImage(60,60,icon));
                }
                else if(count==13){
                    label_13.setIcon(scaleImage(60,60,icon));
                }
                else if(count==14){
                    label_14.setIcon(scaleImage(60,60,icon));
                }
                else if(count==15){
                    label_15.setIcon(scaleImage(60,60,icon));
                }
                else if(count==16){
                    label_16.setIcon(scaleImage(60,60,icon));
                }
                else if(count==17){
                    label_17.setIcon(scaleImage(60,60,icon));
                }
                else if(count==18){
                    label_18.setIcon(scaleImage(60,60,icon));
                }
                else if(count==19){
                    label_19.setIcon(scaleImage(60,60,icon));
                }
                else if(count==20){
                    label_20.setIcon(scaleImage(60,60,icon));
                }
                else if(count==21){
                    label_21.setIcon(scaleImage(60,60,icon));
                }
                else if(count==22){
                    label_22.setIcon(scaleImage(60,60,icon));
                }
                else if(count==23){
                    label_23.setIcon(scaleImage(60,60,icon));
                }
                else if(count==24){
                    label_24.setIcon(scaleImage(60,60,icon));
                }
                else if(count==25){
                    label_25.setIcon(scaleImage(60,60,icon));
                }
                else if(count==26){
                    label_26.setIcon(scaleImage(60,60,icon));
                }
                else if(count==27){
                    label_27.setIcon(scaleImage(60,60,icon));
                }
                else if(count==28){
                    label_28.setIcon(scaleImage(60,60,icon));
                }
                else if(count==29){
                    label_29.setIcon(scaleImage(60,60,icon));
                }
                else if(count==30){
                    label_30.setIcon(scaleImage(60,60,icon));
                }
                else if(count==31){
                    label_31.setIcon(scaleImage(60,60,icon));
                }
                else if(count==32){
                    label_32.setIcon(scaleImage(60,60,icon));
                }
                else if(count==33){
                    label_33.setIcon(scaleImage(60,60,icon));
                }
                else if(count==34){
                    label_34.setIcon(scaleImage(60,60,icon));
                }
                else if(count==35){
                    label_35.setIcon(scaleImage(60,60,icon));
                }
                else if(count==36){
                    label_36.setIcon(scaleImage(60,60,icon));
                }
                else if(count==37){
                    label_37.setIcon(scaleImage(60,60,icon));
                }
                else if(count==38){
                    label_38.setIcon(scaleImage(60,60,icon));
                }
                else if(count==39){
                    label_39.setIcon(scaleImage(60,60,icon));
                }
                else if(count==40){
                    label_40.setIcon(scaleImage(60,60,icon));
                }
                else if(count==41){
                    label_41.setIcon(scaleImage(60,60,icon));
                }
                else if(count==42){
                    label_42.setIcon(scaleImage(60,60,icon));
                }
                else if(count==43){
                    label_43.setIcon(scaleImage(60,60,icon));
                }
                else if(count==44){
                    label_44.setIcon(scaleImage(60,60,icon));
                }
                else if(count==45){
                    label_45.setIcon(scaleImage(60,60,icon));
                }
                else if(count==46){
                    label_46.setIcon(scaleImage(60,60,icon));
                }
                else if(count==47){
                    label_47.setIcon(scaleImage(60,60,icon));
                }
                else if(count==48){
                    label_48.setIcon(scaleImage(60,60,icon));
                }
                else if(count==49){
                    label_49.setIcon(scaleImage(60,60,icon));
                }
                else if(count==50){
                    label_50.setIcon(scaleImage(60,60,icon));
                }
                else if(count==51){
                    label_51.setIcon(scaleImage(60,60,icon));
                }
                else if(count==52){
                    label_52.setIcon(scaleImage(60,60,icon));
                }
                else if(count==53){
                    label_53.setIcon(scaleImage(60,60,icon));
                }
                else if(count==54){
                    label_54.setIcon(scaleImage(60,60,icon));
                }
                else if(count==55){
                    label_55.setIcon(scaleImage(60,60,icon));
                }
                else if(count==56){
                    label_56.setIcon(scaleImage(60,60,icon));
                }
                else if(count==57){
                    label_57.setIcon(scaleImage(60,60,icon));
                }
                else if(count==58){
                    label_58.setIcon(scaleImage(60,60,icon));
                }
                else if(count==59){
                    label_59.setIcon(scaleImage(60,60,icon));
                }
                else if(count==60){
                    label_60.setIcon(scaleImage(60,60,icon));
                }
                else if(count==61){
                    label_61.setIcon(scaleImage(60,60,icon));
                }
                else if(count==62){
                    label_62.setIcon(scaleImage(60,60,icon));
                }
                else if(count==63){
                    label_63.setIcon(scaleImage(60,60,icon));
                }
                else if(count==64){
                    label_64.setIcon(scaleImage(60,60,icon));
                }
                else if(count>64){
                    System.out.printf("存储空间超出的限定");
                }
            }
        });
        btnNewButton_4.setBounds(25, 10, 68, 23);
        panel_3.add(btnNewButton_4);

        JPanel panel_5 = new JPanel();
        panel_5.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
        contentPane.add(panel_5, BorderLayout.SOUTH);

        JButton btnNewButton_6 = new JButton("\u4FDD\u5B58");
        btnNewButton_6.addActionListener(new ActionListener() {
            //			btnNewButton_6鼠标监听，将最后获得的图片保存起来
            public void actionPerformed(ActionEvent e) {
                FileDialog fc = new FileDialog(frm, "保存图片",FileDialog.SAVE);
                fc.setVisible(true);
                String f =fc.getDirectory()+fc.getFile();
                File file = new File(f+""+"."+"jpg");
                try {
                    ImageIO.write(IM, "jpg", file);
                }catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
        });
        panel_5.add(btnNewButton_6);
    }
}



