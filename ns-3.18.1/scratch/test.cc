#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/mobility-module.h"
#include "ns3/wifi-module.h"
#include "ns3/applications-module.h"
#include "ns3/internet-module.h"
#include "ns3/sbra-wifi-manager.h"
#include "ns3/fb-headers.h"

using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("MULTICAST_TEST");

uint32_t data = 0;
uint32_t rxdrop = 0;
uint32_t rxnum = 0;

static void 
RxNum(Ptr<const Packet> pkt)
{
	if(pkt->GetSize () >= 1000)
		rxnum++;
}
static void 
RxDrop(Ptr<const Packet> pkt )
{
	if(pkt->GetSize () >= 1000)
		rxdrop++;
}
static void 
RxData(Ptr <const Packet> pkt, const Address &a)
{
	if(pkt->GetSize () >= 1000)
		data += pkt->GetSize (); 
}
static void
SetGroupTxMode(Ptr<RegularWifiMac> txRegMac, uint64_t period)
{
	NS_LOG_INFO("Get Group mode");
	txRegMac->GetWifiRemoteStationManager()->GroupRateAdaptation();
	Simulator::Schedule(MicroSeconds(period), &SetGroupTxMode, txRegMac, period);
}

int
main (int argc, char *argv[])
{
	uint32_t txNodeNum = 1;
	uint32_t rxNodeNum = 1;
	uint32_t seed = 1; // 1:1:100 
	uint32_t type = 0; // 0 or 1 0-> per over 0.001 1-> maximun throughput 
	uint64_t period = 100; // MilliSeconds
	double dopplerVelocity = 0.5; // 0.5:0.5:2
	double bound = 10.0; //10.0:10.0:100.0
	double perThreshold = 0.001;
	double endTime = 5;
	
	CommandLine cmd;
	cmd.AddValue("TxNodeNum", "Number of tx nodes", txNodeNum);
	cmd.AddValue("RxNodeNum", "Number of rx nodes", rxNodeNum);
	cmd.AddValue ("Seed", "Seed of simulation", seed);
	cmd.AddValue ("Type", "Type of rate adaptation", type);
	cmd.AddValue ("Period", "Seed of simulation", period);
	cmd.AddValue ("Doppler", "Doppler Velocity", dopplerVelocity);
	cmd.AddValue ("Bound", "Rectangular bound of topology", bound);
	cmd.AddValue ("EndTime", "Simulator runtime", endTime);
	cmd.AddValue ("PerThreshold", "threshold of per", perThreshold);
	cmd.AddValue ("EndTime", "Simulation time", endTime);
	cmd.Parse (argc, argv);
	
	SeedManager::SetRun(seed);

	NS_LOG_UNCOND("seed: " << seed << " type: " << type << " period: " << period <<  " doppler: " << dopplerVelocity << " bound: " << bound);
	NodeContainer txNodes, rxNodes;
	txNodes.Create (txNodeNum);
	rxNodes.Create (rxNodeNum);

	WifiHelper wifi = WifiHelper::Default();
	YansWifiPhyHelper wifiPhy = YansWifiPhyHelper::Default();
	wifiPhy.SetPcapDataLinkType (YansWifiPhyHelper::DLT_IEEE802_11_RADIO);

	std::string rateControl("ns3::SbraWifiManager");
	wifi.SetRemoteStationManager (rateControl);
	
	YansWifiChannelHelper wifiChannel; 
	wifiChannel.SetPropagationDelay ("ns3::ConstantSpeedPropagationDelayModel"); 
	wifiChannel.AddPropagationLoss ("ns3::LogDistancePropagationLossModel", "Exponent", DoubleValue(3.5));

	double dopplerFrq = dopplerVelocity*50/3; 
	wifiChannel.AddPropagationLoss("ns3::JakesPropagationLossModel");
	Config::SetDefault ("ns3::JakesProcess::DopplerFrequencyHz", DoubleValue (dopplerFrq));
	Config::SetDefault ("ns3::SbraWifiManager::Type", UintegerValue (type));
	Config::SetDefault ("ns3::SbraWifiManager::PerThreshold", DoubleValue (perThreshold));
	
	wifiPhy.SetChannel (wifiChannel.Create ());
	NqosWifiMacHelper wifiMac = NqosWifiMacHelper::Default(); 

	Ssid ssid = Ssid ("wifi-default"); 

	wifiMac.SetType ("ns3::AdhocWifiMac", "Ssid", SsidValue (ssid)); 
	NetDeviceContainer txDevice = wifi.Install (wifiPhy, wifiMac, txNodes); 
	NetDeviceContainer rxDevice = wifi.Install (wifiPhy, wifiMac, rxNodes);

	MobilityHelper txMobility, rxMobility; 
	
	txMobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");
	Ptr<ListPositionAllocator> positionAlloc = CreateObject<ListPositionAllocator> ();
	positionAlloc->Add (Vector (0.0, 0.0, 0.0));
	positionAlloc->Add (Vector (bound, 0.0, 0.0));
	
	txMobility.SetPositionAllocator (positionAlloc);
  txMobility.Install (txNodes.Get (0));

	rxMobility.SetPositionAllocator (positionAlloc);
  rxMobility.Install (rxNodes.Get (0));
	
	/*
  rxMobility.SetMobilityModel ("ns3::RandomWalk2dMobilityModel", 
															 "Bounds", RectangleValue(Rectangle(-bound,bound,-bound,bound)));

	rxMobility.SetPositionAllocator ("ns3::RandomDiscPositionAllocator", 
																	 "X", StringValue ("0.0"),
																	 "Y", StringValue ("0.0"),
																	 "Rho", StringValue ("ns3::UniformRandomVariable[Min=0|Max=30]"));
  rxMobility.Install (rxNodes);
	*/

	InternetStackHelper stack;
	stack.Install (txNodes);
	stack.Install (rxNodes);
  
  Ipv4AddressHelper ipv4Addr;
	ipv4Addr.SetBase ("10.1.1.0", "255.255.255.0");
  ipv4Addr.Assign (txDevice);
  ipv4Addr.Assign (rxDevice);

  Ipv4Address multicastSource ("10.1.1.1");
  Ipv4Address multicastGroup ("224.100.100.1");

  Ipv4StaticRoutingHelper multicast;
	
	Ptr<Node> sender = txNodes.Get (0);
	Ptr<NetDevice> senderIf = txDevice.Get (0);
	multicast.SetDefaultMulticastRoute (sender, senderIf);
		
	Ptr<WifiNetDevice> txNetDevice = txDevice.Get(0)->GetObject<WifiNetDevice> ();
	Ptr<WifiMac> txMac = txNetDevice->GetMac ();
	Ptr<RegularWifiMac> txRegMac = DynamicCast<RegularWifiMac> (txMac);
	
	uint16_t multicastPort = 9;

	OnOffHelper onoff ("ns3::UdpSocketFactory", Address (InetSocketAddress (multicastGroup, multicastPort)));
	onoff.SetAttribute("OnTime",StringValue("ns3::ConstantRandomVariable[Constant=1]"));
	onoff.SetAttribute("OffTime",StringValue("ns3::ConstantRandomVariable[Constant=0]"));
	onoff.SetAttribute ("PacketSize", UintegerValue(1000));
	onoff.SetAttribute ("DataRate", StringValue ("50Mbps"));

	ApplicationContainer txApp = onoff.Install (txNodes.Get (0));

	txApp.Start (Seconds (0.0));
	txApp.Stop (Seconds (endTime));

	PacketSinkHelper sink ("ns3::UdpSocketFactory",	InetSocketAddress (Ipv4Address::GetAny (), multicastPort));
	
	ApplicationContainer rxApp = sink.Install (rxNodes);
	rxApp.Start (Seconds (0.0));
	rxApp.Stop (Seconds (endTime));
	rxApp.Get (0)->TraceConnectWithoutContext ("Rx", MakeCallback (&RxData));
	rxDevice.Get(0)->GetObject<WifiNetDevice>()->GetPhy()->TraceConnectWithoutContext("PhyRxDrop", MakeCallback(&RxDrop));
	rxDevice.Get(0)->GetObject<WifiNetDevice>()->GetPhy()->TraceConnectWithoutContext("PhyRxEnd", MakeCallback(&RxNum));

	Simulator::Schedule (MilliSeconds (period), &SetGroupTxMode, txRegMac, period);
	wifiPhy.EnablePcapAll ("multicast-test");
	

	NS_LOG_UNCOND ("Run Simulation");
	Simulator::Stop (Seconds (endTime));
  Simulator::Run ();
  Simulator::Destroy ();
	
	std::ofstream fout;
	std::ostringstream out_filename;
	out_filename << "result_151013/MRA_" << seed << "_" << type << "_" << period <<  "_" << dopplerVelocity << "_" << bound << ".txt";
	fout.open(out_filename.str().c_str(), std::ostream::out);
	
  if(!fout.good())
  NS_LOG_UNCOND("File open failed");
	fout << "multicastrateadapt_seed" << seed << "_type" << type << "_period" << period <<  "_doppler" << dopplerVelocity << "_bound" << bound << std::endl;
  fout << "Throughput " <<(double)data*8/1000/1000/endTime<<" Mb/s"<<std::endl;
  fout << "PER " <<(double)(rxdrop)/(double)(rxnum+rxdrop)<<std::endl;
  fout.close();

	NS_LOG_UNCOND("Throughput: "<< (double)data*8/1000/1000/endTime << " Mbps");
	NS_LOG_UNCOND("rxdrop: "<<rxdrop);
	NS_LOG_UNCOND("rxnum: "<<rxnum);
	NS_LOG_UNCOND("PER: "<<(double)(rxdrop)/(double)(rxnum+rxdrop));
}
