#include "come_on_packet.h"


void come_on_packet(parse *ps)
{
    int ret;
    int ch=0;
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t *pcd;
    const u_int8_t *packet;
    struct pcap_pkthdr *pkthdr;
    pcd=pcap_open_live(ps->using_interface(),BUFSIZ,1,1,errbuf);
    char srcIP[16];
    char destIP[16];
    while(true)
    {
        ret=pcap_next_ex(pcd, &pkthdr, &packet);
        switch (ret)
        {
            case 1:
            {
                int packet_len = pkthdr->len;
                cout << "-------- [+] Packet is coming / Packet Length: " << packet_len << " --------"<< endl;
                struct ether_header *ep= (struct ether_header*)packet;
                if(ep->ether_type==ntohs(ETHERTYPE_IP))
                {
                    cout << "\n [ IP Packet Information ]" << endl;
                    struct iphdr *iph = (struct iphdr*)(packet+sizeof(ether_header));
                    inet_ntop(AF_INET, &iph->saddr, srcIP, sizeof(srcIP));
                    inet_ntop(AF_INET, &iph->daddr ,destIP, sizeof(destIP));
                    if(iph->protocol==0x11)
                    {
                        cout << " [ UDP Header] " << endl;
                        //cout<<" [*] Src UDP Port : "<<ntohs(udph->source)<<endl;
                        //cout<<" [*] Dst UDP Port : "<<ntohs(udph->dest)<<endl;
                        struct udphdr *udph = (struct udphdr*)(packet+sizeof(ether_header)+iph->ihl*4);
                        cout << " " << srcIP << ":" << ntohs(udph->source) << " -> " << destIP << ":" << ntohs(udph->dest) << " [UDP]\n" <<endl;
                        cout << " Ether + IP + UDP = " << sizeof(ether_header) + iph->ihl*4 + udph->uh_ulen << endl; // to be deleted 
                        packet_len -= sizeof(ether_header) + iph->ihl*4 + udph->uh_ulen;
                        packet += sizeof(ether_header) + iph->ihl*4 + udph->uh_ulen;
                        cout << " [*] Data Field / Data Length : " << packet_len << endl;
                        if(packet_len > 0){
                            for(int i=0; i<packet_len; i++){
                                cout << packet[i];
                            }
                        }
                        else
                            cout << " => No Data in this Packet :(" << endl;
                        cout << "\n" << endl;
                    }
                    else if(iph->protocol==0x06)
                    {
                        cout << " [ TCP Header] " << endl;
                        //cout<<" [*] Src TCP Port : "<<ntohs(tcph->source)<<endl;
                        //cout<<" [*] Dst TCP Port : "<<ntohs(tcph->dest)<<endl;
                        struct tcphdr *tcph = (struct tcphdr*)(packet+sizeof(ether_header)+iph->ihl*4);
                        cout << " " << srcIP << ":" << ntohs(tcph->source) << " -> " << destIP << ":" << ntohs(tcph->dest) << " [TCP]\n" <<endl;
                        cout << " Ether + IP + TCP = " << sizeof(ether_header) + iph->ihl*4 + tcph->th_off*4 << endl; // to be deleted
                        packet_len -= sizeof(ether_header) + iph->ihl*4 + tcph->th_off*4;
                        packet += sizeof(ether_header) + iph->ihl*4 + tcph->th_off*4;
                        cout << " [*] Data Field / Data Length : " << packet_len << endl;
                        if(packet_len > 0){
                            for(int i=0; i<packet_len; i++){
                                cout << packet[i];
                            }
                        }
                        else
                            cout << " => No Data in this Packet :(" << endl;
//                        while(packet_len--)  //패킷의 오리지널 길이
//                        {
//                           printf("%02x ", *(packet++)); //02x = 두 칸으로 16진수를 표기
//                           if((++ch % 16) == 0) //패킷부분을 볼때 보통 16진수를 16개를 한줄에 두기때문
//                                printf("\n");
//                        }
                        cout << "\n" << endl;
                    }
                }
                if(ep->ether_type==ntohs(ETHERTYPE_ARP))
                    cout << "ARP packet is comming" << endl;
            }
            break;
            case 0:
                continue;
            case -1:
            {
                cout << ">> Error \n";
                pcap_close(pcd);
                sleep(1);
                pcd = pcap_open_live(ps->using_interface(), BUFSIZ, 1 , 1, errbuf);
            }
            break;
            case -2:
            {
                cout << "EOF\n";
            }
            break;
            default:
            break;
        }
    }
}
