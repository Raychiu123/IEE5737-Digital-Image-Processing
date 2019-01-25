#include <iostream>
#include <string>
#include <fstream>
using namespace std;

typedef unsigned char   BYTE;
typedef unsigned short  WORD;
typedef unsigned long   DWORD;

#pragma pack(push)  //防止C++自動優化 
#pragma pack(2)

struct BMPHEADER{  //define the structure of bmp header
	WORD bfType;
    DWORD bfSize;
    WORD bfReserved1;
    WORD bfReserved2;
    DWORD bfOffBits;
};

struct BMPINFOHEADER{  //define the structure of bmpinfo header
    DWORD biSize;
    long biWidth;
    long biHeight;
    WORD biPlanes;
    WORD biBitCount;
    DWORD biCompression;
    DWORD biSizeImage;
    long biXPelsPerMeter;
    long biYPelsPerMeter;
    DWORD biClrUsed;
    DWORD biClrImportant;
};

void print(BMPHEADER h){  //print bmp header
	cout << "===BMPHEADER==="<<'\n';
	cout << "bfType: " << h.bfType<<'\n';
	cout << "bfSize: " << h.bfSize<<'\n';
	cout << "bfReserved1: " << h.bfReserved1  << '\n';
	cout << "bfReserved2: " << h.bfReserved2  << '\n';
    cout << "bfOffBits: "   << h.bfOffBits    << '\n';
}

void print(BMPINFOHEADER h){ //print bmpinfo header 
	cout << "===BMPINFO==="<<'\n';
	cout << "biSize=\t"       << h.biSize       << '\n';
    cout << "biWidth=\t"        << h.biWidth      << '\n';
    cout << "biHeight=\t"       << h.biHeight     << '\n';
    cout << "biPlanes=\t"       << h.biPlanes     << '\n';
    cout << "biBitCount=\t"     << h.biBitCount   <<'\n';  //每個pixel的bytes 
    cout << "biCompression=\t"  << h.biCompression    << '\n';
    cout << "biSizeImage=\t"    << h.biSizeImage      << '\n';
    cout << "biXPelsPerMeter="  << h.biXPelsPerMeter  << '\n';
    cout << "biYPelsPerMeter="  << h.biYPelsPerMeter  << '\n';
    cout << "biClrUsed=\t"      << h.biClrUsed        << '\n';
    cout << "biClrImportant=\t" << h.biClrImportant   << '\n';
}

class ImageMatrix{   //for input1
	public:
		int h,w,rowsize;
		BYTE* term;
	ImageMatrix(){
		h=w=0;
	}
	ImageMatrix(int height, int width){
		h = height;
		w = width;
		rowsize = (4*width);
		term = new BYTE[height*rowsize];
	}
	bool Load(char *file){
		BMPHEADER head;
		BMPINFOHEADER hinfo;
		ifstream f;
		f.open(file,ios::in|ios::binary);
		f.seekg(0,f.end);
		cout << "The size of BMP : "<< f.tellg() << "bytes" <<'\n';
		f.seekg(0,f.beg);
		f.read((char*)&head, sizeof(head));
		f.read((char*)&hinfo, sizeof(hinfo));
		print (head);
		print (hinfo);
		w = hinfo.biWidth;
		h = hinfo.biHeight;
		*this = ImageMatrix(h,w);
		f.read((char*)term, rowsize *h);
		f.close();		
	}
	bool Save(char *filename){
		BMPHEADER head={
		0x4d42,
		54L + rowsize*h,
		0,
		0,
		54
		};
		BMPINFOHEADER hinfo={
		sizeof(BMPINFOHEADER),
		w,
		h,
		1,
		32,
		0,
		rowsize*h,
		13776,
		13776,
		0,
		0};
		cout << "writing info : " << filename<<'\n' ;
		ofstream f;
		f.open(filename,ios::binary);
		f.write((char*)&head, sizeof(head));
		f.write((char*)&hinfo, sizeof(hinfo));
		f.write((char*)term, rowsize*h);
		f.close(); 
	}
};

class ImageMatrix1{  //for input2
	public:
		int h,w,rowsize;
		BYTE* term;
	ImageMatrix1(){
		h=w=0;
	}
	ImageMatrix1(int height, int width){
		h = height;
		w = width;
		rowsize = (3*width+3);
		term = new BYTE[height*rowsize];
	}
	bool Load(char *file){
		BMPHEADER head;
		BMPINFOHEADER hinfo;
		ifstream f;
		f.open(file,ios::in|ios::binary);
		f.seekg(0,f.end);
		cout << "The size of BMP : "<< f.tellg() << "bytes" <<'\n';
		f.seekg(0,f.beg);
		f.read((char*)&head, sizeof(head));
		f.read((char*)&hinfo, sizeof(hinfo));
		print (head);
		print (hinfo);
		w = hinfo.biWidth;
		h = hinfo.biHeight;
		*this = ImageMatrix1(h,w);
		f.read((char*)term, rowsize *h);
		f.close();		
	}
	bool Save(char *filename){
		BMPHEADER head={
		0x4d42,
		138L + rowsize*h,
		0,
		0,
		138
		};
		BMPINFOHEADER hinfo={
		sizeof(BMPINFOHEADER),
		w,
		h,
		1,
		24,
		0,
		(rowsize)*h,
		2834,
		2834,
		0,
		0};
		cout << "writing info : " << filename<<'\n' ;
		ofstream f;
		f.open(filename,ios::binary);
		f.write((char*)&head, sizeof(head));
		f.write((char*)&hinfo, sizeof(hinfo));
		f.write((char*)term, rowsize*h);
		f.close(); 
	}
};

ImageMatrix scaling_down (ImageMatrix m){         // 縮小,for input1 
	ImageMatrix mm(m.h,m.w*2/3);  
	ImageMatrix mm1(m.h*2/3,m.w*2/3);
	int x1=0;
	int y1=0;
	// 先縮小width 
	for(int y=0;y<mm.h;y++){
		x1 = 0;
		for(int x=0;x<mm.rowsize;x+=4){
			if(x1 % 3 != 2){
				int B = (m.term[y*m.rowsize+x1]+m.term[y*m.rowsize+x1+4])/2;
				int G = (m.term[y*m.rowsize+x1+1]+m.term[y*m.rowsize+x1+5])/2;
				int R = (m.term[y*m.rowsize+x1+2]+m.term[y*m.rowsize+x1+6])/2;					
				int Y = (m.term[y*m.rowsize+x1+3]+m.term[y*m.rowsize+x1+7])/2;
			
				mm.term[y*mm.rowsize + x] =B;
				mm.term[y*mm.rowsize + x+1] =G;					
				mm.term[y*mm.rowsize + x+2] =R;
				mm.term[y*mm.rowsize + x+3] =Y;
				x1+=4;
			}
			else{
				x-=4;
				x1+=4;
			}			
		}
	}
	// 再縮小height 
	for(int y=0;y<mm1.h;y++){
		if(y1 %3 != 2){
			for(int x=0;x<mm1.rowsize;x+=4){
				int B = (mm.term[y1*mm.rowsize+x]+mm.term[(y1+1)*mm.rowsize+x])/2;
				int G = (mm.term[y1*mm.rowsize+x+1]+mm.term[(y1+1)*mm.rowsize+x+1])/2;
				int R = (mm.term[y1*mm.rowsize+x+2]+mm.term[(y1+1)*mm.rowsize+x+2])/2;					
				int Y = (mm.term[y1*mm.rowsize+x+3]+mm.term[(y1+1)*mm.rowsize+x+3])/2;
			
				mm1.term[y*mm1.rowsize + x] =B;
				mm1.term[y*mm1.rowsize + x+1] =G;					
				mm1.term[y*mm1.rowsize + x+2] =R;
				mm1.term[y*mm1.rowsize + x+3] =Y;
			}
			y1++;
		}
		else{
			y--;
			y1++;
		}
	}
	return mm1;
}

ImageMatrix1 scaling1_down (ImageMatrix1 m){       //縮小,for input2
	ImageMatrix1 mm(m.h,(m.w-2)*2/3);
	ImageMatrix1 mm1(m.h*2/3,(m.w-2)*2/3);
	int x1=0;
	int x2=0;
	int y1=0;
	
	for(int y=0;y<mm.h;y++){
		x1 = 0;
		x2 = 0;
		for(int x=0;x<mm.rowsize;x+=3){
			if(x2 % 3 != 2){
				int B = (m.term[y*m.rowsize+x1]+m.term[y*m.rowsize+x1+3])/2;
				int G = (m.term[y*m.rowsize+x1+1]+m.term[y*m.rowsize+x1+4])/2;
				int R = (m.term[y*m.rowsize+x1+2]+m.term[y*m.rowsize+x1+5])/2;
//				int Y = (m.term[y*m.rowsize+x1+3]+m.term[y*m.rowsize+x1+7])/2;					
			
				mm.term[y*mm.rowsize + x] =B;
				mm.term[y*mm.rowsize + x+1] =G;					
				mm.term[y*mm.rowsize + x+2] =R;
//				mm.term[y*mm.rowsize + x+3] =Y;
				x1+=3;
				x2++;
			}
			else{
				x-=3;
				x1+=3;
				x2++;
			}			
		}
	}	
	for(int y=0;y<mm1.h;y++){
		if(y1 %3 != 2){
			for(int x=0;x<mm1.rowsize;x+=3){
				int B = (mm.term[y1*mm.rowsize+x]+mm.term[(y1+1)*mm.rowsize+x])/2;
				int G = (mm.term[y1*mm.rowsize+x+1]+mm.term[(y1+1)*mm.rowsize+x+1])/2;
				int R = (mm.term[y1*mm.rowsize+x+2]+mm.term[(y1+1)*mm.rowsize+x+2])/2;
//				int Y = (mm.term[y1*mm.rowsize+x+3]+mm.term[(y1+1)*mm.rowsize+x+3])/2;					
			
				mm1.term[y*mm1.rowsize + x] =B;
				mm1.term[y*mm1.rowsize + x+1] =G;			
				mm1.term[y*mm1.rowsize + x+2] =R;
//				mm1.term[y*mm1.rowsize + x+3] =Y;
			}
			y1++;
		}
		else{
			y--;
			y1++;
		}
	}
	return mm1;
}

ImageMatrix qutization(ImageMatrix m,int q){       //quantization,for input1
	ImageMatrix mm = ImageMatrix(m.h, m.w);
	for (int y = 0; y<m.h; y++)
		for (int x = 0; x<m.rowsize; x += 4){
			int B = m.term[y*m.rowsize + x];
			int G = m.term[y*m.rowsize + x + 1];
			int R = m.term[y*m.rowsize + x + 2];
			int Y = m.term[y*m.rowsize + x + 3];
			
			int B1 = B >> q;
			int G1 = G >> q;
			int R1 = R >> q;
			int Y1 = Y >> q;
			
			B1 = B1 << q;
			G1 = G1 << q;
			R1 = R1 << q;
			Y1 = Y1 << q;
			
			mm.term[y*m.rowsize + x] = B1;
			mm.term[y*m.rowsize + x + 1] = G1;
			mm.term[y*m.rowsize + x + 2] = R1;
			mm.term[y*m.rowsize + x + 3] = Y1; 
	}
    
	return mm;
}

ImageMatrix qutization1(ImageMatrix m,int q){     //quantization,for input2
	ImageMatrix mm = ImageMatrix(m.h, m.w);
	for (int y = 0; y<m.h; y++)
		for (int x = 0; x<m.rowsize; x += 3){
			int B = m.term[y*m.rowsize + x];
			int G = m.term[y*m.rowsize + x + 1];
			int R = m.term[y*m.rowsize + x + 2];
			
			int B1 = B >> q;
			int G1 = G >> q;
			int R1 = R >> q;
			
			B1 = B1 << q;
			G1 = G1 << q;
			R1 = R1 << q;
			
			mm.term[y*m.rowsize + x] = B1;
			mm.term[y*m.rowsize + x + 1] = G1;
			mm.term[y*m.rowsize + x + 2] = R1; 
	}    
	return mm;
}

ImageMatrix scaling_top (ImageMatrix m){   //放大,for input1 
	ImageMatrix mm(m.h,m.w*3/2);
	ImageMatrix mm1(m.h*3/2,m.w*3/2);
	int x1=0;
	int x2=0;
	int y1=1;
	int y2=0;
	
	for(int y=0;y<mm.h;y++){
		x1 = 0;
		x2 = 0;
		for(int x=0;x<mm.rowsize;x+=4){
			if(x2 % 3 == 2){
				x1-=4;
				int B = (m.term[y*m.rowsize+x1]+m.term[y*m.rowsize+x1+4])/2;
				int G = (m.term[y*m.rowsize+x1+1]+m.term[y*m.rowsize+x1+5])/2;
				int R = (m.term[y*m.rowsize+x1+2]+m.term[y*m.rowsize+x1+6])/2;					
				int Y = (m.term[y*m.rowsize+x1+3]+m.term[y*m.rowsize+x1+7])/2;
			
				mm.term[y*mm.rowsize + x] =B;
				mm.term[y*mm.rowsize + x+1] =G;					
				mm.term[y*mm.rowsize + x+2] =R;
				mm.term[y*mm.rowsize + x+3] =Y;
				x1+=4;
				x2++;
			}
			else{
				mm.term[y*mm.rowsize + x] =m.term[y*m.rowsize+x1];
				mm.term[y*mm.rowsize + x+1] =m.term[y*m.rowsize+x1+1];					
				mm.term[y*mm.rowsize + x+2] =m.term[y*m.rowsize+x1+2];
				mm.term[y*mm.rowsize + x+3] =m.term[y*m.rowsize+x1+3];
				x1+=4;
				x2++;
			}			
		}
	}
	
	for(int y=0;y<mm1.h;y++){
		if(y1 % 3 == 2){
			for(int x=0;x<mm1.rowsize;x+=4){
				int B = (mm.term[y2*mm.rowsize+x]+mm.term[(y2-1)*mm.rowsize+x])/2;
				int G = (mm.term[y2*mm.rowsize+x+1]+mm.term[(y2-1)*mm.rowsize+x+1])/2;
				int R = (mm.term[y2*mm.rowsize+x+2]+mm.term[(y2-1)*mm.rowsize+x+2])/2;
				int Y = (mm.term[y2*mm.rowsize+x+3]+mm.term[(y2-1)*mm.rowsize+x+3])/2;
			
				mm1.term[y*mm1.rowsize + x] =B;
				mm1.term[y*mm1.rowsize + x+1] =G;					
				mm1.term[y*mm1.rowsize + x+2] =R;
				mm1.term[y*mm1.rowsize + x+3] =Y;
			}
		}
		else{
			for(int x=0;x<mm1.rowsize;x+=4){
				mm1.term[y*mm1.rowsize + x] =mm.term[y2*mm.rowsize+x];
				mm1.term[y*mm1.rowsize + x+1] =mm.term[y2*mm.rowsize+x+1];					
				mm1.term[y*mm1.rowsize + x+2] =mm.term[y2*mm.rowsize+x+2];
				mm1.term[y*mm1.rowsize + x+3] =mm.term[y2*mm.rowsize+x+3];
			}
			y2++;
		}
		y1++;
	}
	return mm1; 
}

ImageMatrix1 scaling_top1 (ImageMatrix1 m){ //放大,for input2 
	ImageMatrix1 mm(m.h,m.w*3/2);
	ImageMatrix1 mm1(m.h*3/2,m.w*3/2);
	int x1=0;
	int x2=1;
	int y1=1;
	int y2=0;
	
	for(int y=0;y<mm.h;y++){
		x1 = 0;
		x2 = 0;
		for(int x=0;x<mm.rowsize;x+=3){
			if(x2 % 3 == 2){
				x1-=3;
				int B = (m.term[y*m.rowsize+x1]+m.term[y*m.rowsize+x1+3])/2;
				int G = (m.term[y*m.rowsize+x1+1]+m.term[y*m.rowsize+x1+4])/2;
				int R = (m.term[y*m.rowsize+x1+2]+m.term[y*m.rowsize+x1+5])/2;					
//				int Y = (m.term[y*m.rowsize+x1+4]+m.term[y*m.rowsize+x1+8])/2;
			
				mm.term[y*mm.rowsize + x] =B;
				mm.term[y*mm.rowsize + x+1] =G;					
				mm.term[y*mm.rowsize + x+2] =R;
//				mm.term[y*mm.rowsize + x+3] =Y;
				x1+=3;
			}
			else{
				mm.term[y*mm.rowsize + x] =m.term[y*m.rowsize+x1];
				mm.term[y*mm.rowsize + x+1] =m.term[y*m.rowsize+x1+1];					
				mm.term[y*mm.rowsize + x+2] =m.term[y*m.rowsize+x1+2];
//				mm.term[y*mm.rowsize + x+3] =m.term[y*m.rowsize+x1+3];
				x1+=3;
			}
			x2++;			
		}
	} 
	
	for(int y=0;y<mm1.h;y++){
		if(y1 % 3 == 2){
			for(int x=0;x<mm1.rowsize;x+=3){
				int B = (mm.term[y2*mm.rowsize+x]+mm.term[(y2-1)*mm.rowsize+x])/2;
				int G = (mm.term[y2*mm.rowsize+x+1]+mm.term[(y2-1)*mm.rowsize+x+1])/2;
				int R = (mm.term[y2*mm.rowsize+x+2]+mm.term[(y2-1)*mm.rowsize+x+2])/2;
//				int Y = (mm.term[y2*mm.rowsize+x+3]+mm.term[(y2-1)*mm.rowsize+x+3])/2;
			
				mm1.term[y*mm1.rowsize + x] =B;
				mm1.term[y*mm1.rowsize + x+1] =G;					
				mm1.term[y*mm1.rowsize + x+2] =R;
//				mm1.term[y*mm1.rowsize + x+3] =Y;
			}
		}
		else{
			for(int x=0;x<mm1.rowsize;x+=3){
				mm1.term[y*mm1.rowsize + x] =mm.term[y2*mm.rowsize+x];
				mm1.term[y*mm1.rowsize + x+1] =mm.term[y2*mm.rowsize+x+1];					
				mm1.term[y*mm1.rowsize + x+2] =mm.term[y2*mm.rowsize+x+2];
//				mm1.term[y*mm1.rowsize + x+3] =mm.term[y2*mm.rowsize+x+3];
			}
			y2++;
		}
		y1++;
	}
	return mm1;  
}

int main(){
    ImageMatrix m,mm;
    cout << "===input1==="<<'\n';
    

    m.Load("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\input1.bmp");    // read input1
	m.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output1.bmp");   // write output1
	
	cout << "\n===input2==="<<'\n';
	ImageMatrix1 m1,mm1;
	m1.Load("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\input2.bmp");  //read input2
	m1.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output2.bmp"); //save output2
    
	int q;								//量化位階 0<=q<=7 
	cout << "\nquantization q = " ;   
	cin >> q;

	mm = qutization(m,q); //量化 input1 
	mm.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output1_3.bmp");
	
	mm1 = qutization(m1,q); //量化 input2 
	mm1.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output2_3.bmp"); 

	mm = scaling_down(m);   //縮小 input1 
	mm.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output1_down.bmp");	
	mm1 = scaling1_down(m1);  //縮小 input2 
	mm1.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output2_down.bmp");
	
	mm = scaling_top(m);  //放大 input1 
	mm.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output1_top.bmp");
	mm1 = scaling_top1(m1); //放大 input2 
	mm1.Save("C:\\Users\\gaexp\\OneDrive\\Documents\\Digital Image Processing\\Homework\\HW1\\output2_top.bmp");
	
	
	
	system("pause");
    return 0 ;
}
